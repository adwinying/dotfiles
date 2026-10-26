--
-- browser_spaces.lua
-- Arc-like spaces for Helium: each space is a named profile window,
-- swapped in and out of a single slot via an AeroSpace parking workspace
--

local config = require("configs").browser_spaces
local wm = require("modules.wm")

BrowserSpaces = {}

-- =============================================================================
-- Windows
-- =============================================================================

-- Helium titles named windows "<window name> - [Part of group <group> - ]Helium - <profile name>"
local function is_space_window (space, title)
  local prefix = space.name .. " - "
  local suffix = " - Helium - " .. space.profile

  return title:sub(1, #prefix) == prefix and title:sub(-#suffix) == suffix
end

local function is_any_space_window (title)
  return hs.fnutils.some(config.spaces, function (space) return is_space_window(space, title) end)
end

local function list_windows ()
  local output = wm.execute_aerospace("list-windows --all --format '%{window-id}|%{app-bundle-id}|%{workspace}|%{window-title}'")
  local windows = {}

  for id, app_id, workspace, title in output:gmatch("(%d+)|([^|]*)|([^|]*)|([^\n]*)") do
    if app_id == config.app_id then
      table.insert(windows, { id = id, workspace = workspace, title = title })
    end
  end

  return windows
end

local function find_window (space)
  return hs.fnutils.find(list_windows(), function (win) return is_space_window(space, win.title) end)
end

-- poll until predicate returns truthy, then call callback with its result
local function wait_for (predicate, callback)
  local attempts = 0

  hs.timer.doUntil(function () return attempts >= 25 end, function (timer)
    attempts = attempts + 1
    local result = predicate()

    if result then
      timer:stop()
      callback(result)
    end
  end, 0.2)
end

-- =============================================================================
-- Spaces
-- =============================================================================

-- open a new window for the space's profile, name it, then switch to it
function BrowserSpaces:spawn (space)
  local known_ids = {}
  for _, win in ipairs(list_windows()) do known_ids[win.id] = true end

  hs.execute(string.format("open -na %s --args --new-window --profile-directory='%s'", config.app_name, space.profile_dir))

  -- launching a profile may restore its named windows instead of opening a new one
  wait_for(function ()
    return find_window(space) or hs.fnutils.find(list_windows(), function (win) return not known_ids[win.id] end)
  end, function (win)
    if not is_space_window(space, win.title) then
      wm.execute_aerospace("focus --window-id " .. win.id)
      hs.osascript.applescript(string.format(
        'tell application "%s" to set given name of front window to "%s"', config.app_name, space.name
      ))
    end

    wait_for(function () return find_window(space) end, function () self:switch(space) end)
  end)
end

-- show the space's window in the focused workspace, park other space windows
function BrowserSpaces:switch (space)
  local target = find_window(space)

  if target == nil then return self:spawn(space) end

  local workspace = wm.execute_aerospace("list-workspaces --focused"):gsub("%s", "")

  wm.execute_aerospace(string.format("move-node-to-workspace --window-id %s %s", target.id, workspace))

  for _, win in ipairs(list_windows()) do
    if win.workspace == workspace and win.id ~= target.id and is_any_space_window(win.title) then
      wm.execute_aerospace(string.format("move-node-to-workspace --window-id %s %s", win.id, config.parked_workspace))
    end
  end

  wm.execute_aerospace("focus --window-id " .. target.id)
end

-- focus a visible Helium window without jumping to the parking workspace
function BrowserSpaces:focus ()
  local visible = hs.fnutils.find(list_windows(), function (win)
    return win.workspace ~= config.parked_workspace
  end)

  if visible == nil then return hs.application.launchOrFocus(config.app_name) end

  wm.execute_aerospace("focus --window-id " .. visible.id)
end

-- =============================================================================
-- Hotkeys (active only while Helium is focused)
-- =============================================================================

BrowserSpaces.hotkeys = hs.fnutils.map(config.spaces, function (space)
  return hs.hotkey.new(config.modifiers, space.key, function () BrowserSpaces:switch(space) end)
end)

local function set_hotkeys_enabled (enabled)
  for _, hotkey in ipairs(BrowserSpaces.hotkeys) do
    if enabled then hotkey:enable() else hotkey:disable() end
  end
end

BrowserSpaces.watcher = hs.application.watcher.new(function (name, event)
  if name ~= config.app_name then return end

  if event == hs.application.watcher.activated then set_hotkeys_enabled(true) end
  if event == hs.application.watcher.deactivated then set_hotkeys_enabled(false) end
end):start()

local frontmost = hs.application.frontmostApplication()
set_hotkeys_enabled(frontmost ~= nil and frontmost:name() == config.app_name)
