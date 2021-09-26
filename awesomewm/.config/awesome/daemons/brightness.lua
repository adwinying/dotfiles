--
-- brightness.lua
-- brightness daemon
-- Dependencies:
--   light
--   inotify-tools
--
-- Signals:
-- daemon::brightness::percentage
--   percentage (integer)
--

local awful = require("awful")
local helpers = require("helpers")


-- ========================================
-- Config
-- ========================================

-- script to monitor volume events
-- Subscribe to backlight changes
local monitor_script = "while (inotifywait -e modify /sys/class/backlight/?*/brightness -qq) do echo; done"

-- script to kill monitor script
-- Kills old inotify subscribe processes
local monitor_kill_script = [[ ps x | grep "inotifywait -e modify /sys/class/backlight" | grep -v grep | awk '{print $1}' | xargs kill ]]

local brightness_script = "light -G"


-- ========================================
-- Logic
-- ========================================

-- Main script
local emit_brightness_percentage = function ()
  awful.spawn.easy_async_with_shell(brightness_script, function (stdout)
    local percentage = math.floor(tonumber(stdout))

    awesome.emit_signal("daemon::brightness::percentage", percentage)
  end)
end


-- ========================================
-- Initialization
-- ========================================

-- Run once to initialize widgets
emit_brightness_percentage()


-- Start monitoring process
helpers.start_monitor(
  monitor_script,
  monitor_kill_script,
  { stdout = emit_brightness_percentage }
)
