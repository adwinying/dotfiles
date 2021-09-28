--
-- helpers.lua
-- helper functions
--

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local helpers = {}

-- ========================================
-- Package
-- ========================================

-- Check package exists
helpers.is_module_available = function (name)
  if package.loaded[name] then return true end

  for _, searcher in ipairs(package.searchers or package.loaders) do
    local loader = searcher(name)
    if type(loader) == "function" then
      package.preload[name] = loader
      return true
    end
  end

  return false
end


-- ========================================
-- WM
-- ========================================

-- When layout is max remove gaps
helpers.set_gaps = function (screen, tag)
  local layout = tag.layout
  local topbar = screen.topbar

  if (layout == awful.layout.suit.max) then
    tag.gap = 0
    topbar.x = screen.geometry.x
    topbar.y = screen.geometry.y
    topbar.width = screen.geometry.width
    topbar:struts { top = beautiful.topbar_height }
  else
    tag.gap = beautiful.useless_gap
    topbar.x = screen.geometry.x + beautiful.topbar_margin * 2
    topbar.y = screen.geometry.y + beautiful.topbar_margin * 2
    topbar.width = screen.geometry.width - beautiful.topbar_margin * 4
    topbar:struts { top = beautiful.topbar_height + beautiful.topbar_margin * 2 }
  end
end


-- generate rounded rect shape
helpers.rrect = function (cr, w, h)
  gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
end


-- ========================================
-- Scripts
-- ========================================

-- get main process name
helpers.get_main_process_name = function (cmd)
  -- remove whitespace
  cmd = cmd:gsub("%s+$", "")

  local first_space_idx = cmd:find(" ")

  return first_space_idx ~= nil
    and cmd:sub(0, first_space_idx - 1)
    or  cmd
end


-- start a monitoring script and monitor its output
helpers.start_monitor = function (script, callbacks)
  -- remove whitespace and escape quotes
  script = script:gsub("^%s+", ""):gsub("%s+$", ""):gsub('"', '\\"')

  local monitor_script = string.format(
    [[ bash -c "%s" ]],
    script
  )
  local kill_monitor_script = string.format(
    [[ pkill %s ]],
    helpers.get_main_process_name(script)
  )

  -- First, kill any existing monitor processes
  awful.spawn.easy_async_with_shell(kill_monitor_script, function ()
    -- Start monitor process
    awful.spawn.with_line_callback(monitor_script, callbacks)
  end)
end


-- ========================================
-- Media Controls
-- ========================================

-- Play/Pause
helpers.media_play_pause = function ()
  local cmd = "playerctl play-pause"
  awful.spawn.with_shell(cmd)
end


-- Previous track
helpers.media_prev = function ()
  local cmd = "playerctl previous"
  awful.spawn.with_shell(cmd)
end


-- Next track
helpers.media_next = function ()
  local cmd = "playerctl next"
  awful.spawn.with_shell(cmd)
end


-- ========================================
-- Volume
-- ========================================

-- change volume
helpers.change_volume = function (change_by)
  local percentage = change_by < 0
    and string.format("-%s%%", -change_by)
    or  string.format("+%s%%", change_by)

  local cmd = "pactl set-sink-volume @DEFAULT_SINK@ " .. percentage

  awful.spawn.with_shell(cmd)
end


-- toggle volume mute
helpers.toggle_volume_mute = function ()
  local cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
  awful.spawn.with_shell(cmd)
end


-- ========================================
-- Brightness
-- ========================================

-- change brightness
helpers.change_brightness = function (change_by)
  local cmd = change_by < 0
    and "light -U " .. -change_by
    or  "light -A " .. change_by

  awful.spawn.with_shell(cmd)
end


return helpers
