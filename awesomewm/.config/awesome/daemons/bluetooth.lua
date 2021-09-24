--
-- bluetooth.lua
-- bluetooth daemon
--
-- Dependencies:
--   bluez
--   bluez-utils
--
-- Signals:
-- daemon::bluetooth::status
--   active (boolean)
--

local awful = require("awful")
local gears = require("gears")

-- ========================================
-- Config
-- ========================================

-- update interval
local update_interval = 30
-- script to get bluetooth status
local status_script = "bluetoothctl --monitor list"


-- ========================================
-- Logic
-- ========================================

-- Main script
local check_bluetooth = function ()
  awful.spawn.easy_async_with_shell(status_script, function(stdout)
    local active = stdout:match("Controller") ~= nil

    awesome.emit_signal("daemon::bluetooth::status", active)
  end)
end


-- ========================================
-- Initialization
-- ========================================

gears.timer {
  timeout = update_interval,
  autostart = true,
  call_now = true,
  callback = check_bluetooth,
}
