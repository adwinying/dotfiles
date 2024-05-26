--
-- wm.lua
-- Window manager related keybindings
--

local helpers = require("helpers")
local hyper = require("modules.hyper")
local wm = require("modules.wm")
local config = require("configs").wm

-- =============================================================================
-- Layouts
-- =============================================================================

-- select floating layout
hyper:bind({ "shift" }, "s", function ()
  if config.mode == "yabai" then
    wm.api.config("--space mouse layout float")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace enable toggle")
  end

  Layouts:update("float")
end)

-- select bsp layout
hyper:bind({}, "s", function ()
  if config.mode == "yabai" then
    wm.api.config("--space mouse layout bsp")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace layout h_tiles")
  end

  Layouts:update("bsp")
end)

-- select stack layout
hyper:bind({}, "w", function ()
  if config.mode == "yabai" then
    wm.api.config("--space mouse layout stack")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace layout h_accordion")
  end

  Layouts:update("stack")
end)


-- =============================================================================
-- Display navigation
-- =============================================================================

-- move to display #
for i = 1, 9 do
  hyper:bind({ "cmd" }, tostring(i), function ()
    if config.mode == "yabai" then
      wm.api.display.focus(nil, i)
    end
  end)
end


-- =============================================================================
-- Space navigation
-- =============================================================================

-- move to space #
for i = 1, 9 do
  hyper:bind({}, tostring(i), function ()
    if config.compatibility_mode then
      hs.eventtap.keyStroke({ "ctrl", "alt", "cmd", "shift" }, tostring(i))
      return
    end

    if config.mode == "yabai" then
      wm.api.space.focus(nil, i)
    end

    if config.mode == "aerospace" then
      hs.execute(string.format("aerospace workspace %s", i))
    end
  end)
end


-- =============================================================================
-- Window navigation
-- =============================================================================

-- move to left window
hyper:bind({}, "h", function ()
  if config.mode == "yabai" then
    wm.api.window.focus(nil, "west")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace focus left")
  end
end)

-- move to bottom window
-- cycle next windows in monocle mode
hyper:bind({}, "j", function ()
  if config.mode == "yabai" then
    if wm.get_current_layout() == "stack" then
      wm.api.window.focus(nil, "stack.next")
    else
      wm.api.window.focus(nil, "south")
    end
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace focus down")
  end
end)

-- move to top window
-- cycle previous windows in monocle mode
hyper:bind({}, "k", function ()
  if config.mode == "yabai" then
    if wm.get_current_layout() == "stack" then
      wm.api.window.focus(nil, "stack.prev")
    else
      wm.api.window.focus(nil, "north")
    end
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace focus up")
  end
end)

-- move to right window
hyper:bind({}, "l", function ()
  if config.mode == "yabai" then
    wm.api.window.focus(nil, "east")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace focus right")
  end
end)


-- =============================================================================
-- Window move
-- =============================================================================

-- move window left
hyper:bind({ "shift" }, "h", function ()
  if config.mode == "yabai" then
    wm.move_window("west")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace move left")
  end
end)

-- move window down
hyper:bind({ "shift" }, "j", function ()
  if config.mode == "yabai" then
    wm.move_window("south")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace move down")
  end
end)

-- move window up
hyper:bind({ "shift" }, "k", function ()
  if config.mode == "yabai" then
    wm.move_window("north")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace move up")
  end
end)

-- move window right
hyper:bind({ "shift" }, "l", function ()
  if config.mode == "yabai" then
    wm.move_window("east")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace move right")
  end
end)

-- move window to left screen
hyper:bind({ "cmd", "shift" }, "h", function ()
  if config.mode == "yabai" then
    wm.api.window.display(nil, "west")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace move-node-to-monitor left")
  end
end)

-- move window to bottom screen
hyper:bind({ "cmd", "shift" }, "j", function ()
  if config.mode == "yabai" then
    wm.api.window.display(nil, "south")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace move-node-to-monitor down")
  end
end)

-- move window to top screen
hyper:bind({ "cmd", "shift" }, "k", function ()
  if config.mode == "yabai" then
    wm.api.window.display(nil, "north")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace move-node-to-monitor up")
  end
end)

-- move window to right screen
hyper:bind({ "cmd", "shift" }, "l", function ()
  if config.mode == "yabai" then
    wm.api.window.display(nil, "east")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace move-node-to-monitor right")
  end
end)


-- =============================================================================
-- Window resize
-- =============================================================================

-- resize window left
hyper:bind({ "ctrl" }, "h", function ()
  if config.mode == "yabai" then
    wm.resize_window("west")
  end

  if config.mode == "aerospace" then
    hs.execute(string.format("aerospace resize width -%s", config.resize_step))
  end
end)

--  resize window down
hyper:bind({ "ctrl" }, "j", function ()
  if config.mode == "yabai" then
    wm.resize_window("south")
  end

  if config.mode == "aerospace" then
    hs.execute(string.format("aerospace resize height -%s", config.resize_step))
  end
end)

--  resize window up
hyper:bind({ "ctrl" }, "k", function ()
  if config.mode == "yabai" then
    wm.resize_window("north")
  end

  if config.mode == "aerospace" then
    hs.execute(string.format("aerospace resize height +%s", config.resize_step))
  end
end)

--  resize window right
hyper:bind({ "ctrl" }, "l", function ()
  if config.mode == "yabai" then
    wm.resize_window("east")
  end

  if config.mode == "aerospace" then
    hs.execute(string.format("aerospace resize width +%s", config.resize_step))
  end
end)


-- =============================================================================
-- Window management
-- =============================================================================

-- Toggle float
hyper:bind({ "ctrl" }, "space", function ()
  if config.mode == "yabai" then
    wm.api.window.toggle(nil, "float")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace layout floating tiling")
  end

  Layouts:update()
end)

-- Toggle full screen
hyper:bind({}, "f", function ()
  if config.mode == "yabai" then
    wm.api.window.toggle(nil, "native-fullscreen")
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace fullscreen")
  end
end)

-- Toggle sticky
hyper:bind({}, "t", function ()
  if config.mode == "yabai" then
    wm.api.window.toggle(nil, "sticky")
  end
end)

-- Minimize window
hyper:bind({}, "n", function ()
  if config.mode == "yabai" then
    wm.api.window.minimize()
    helpers.get_active_window(function (win) win:focus() end)
  end

  if config.mode == "aerospace" then
    hs.eventtap.keyStroke({ "cmd" }, "h")
    return
  end
end)

-- Restore minimized windows
hyper:bind({ "shift" }, "n", function ()
  if config.mode == "aerospace" then return end

  local space_windows = wm.get_active_space_windows()
  local minimized_windows = hs.fnutils.filter(space_windows, function (win)
    return win["is-minimized"]
  end)

  for _, win in ipairs(minimized_windows) do
    wm.api.window.deminimize(nil, win.id)
  end

  helpers.get_active_window(function (win) win:focus() end)
end)

-- Close
hyper:bind({ "shift" }, "c", function ()
  if config.mode == "yabai" then
    wm.api.window.close()
  end

  if config.mode == "aerospace" then
    hs.execute("aerospace close")
  end
end)

-- Move window to space #
for i = 1, 9 do
  hyper:bind({ "shift" }, tostring(i), function ()
    if config.mode == "yabai" then
      wm.api.window.space(nil, i)
    end

    if config.mode == "aerospace" then
      hs.execute(string.format("aerospace move-node-to-workspace %s", i))
    end
  end)
end
