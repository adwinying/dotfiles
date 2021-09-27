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
local helpers = require("helpers")

-- ========================================
-- Config
-- ========================================

-- script to check bluetooth status
local check_script = "bluetoothctl list"

-- script to monitor bluetooth status
local monitor_script = "bluetoothctl --monitor list"


-- ========================================
-- Logic
-- ========================================

-- Main script
local check_bluetooth = function (stdout)
  local active = stdout:match("Controller") ~= nil

  awesome.emit_signal("daemon::bluetooth::status", active)
end


-- ========================================
-- Initialization
-- ========================================

-- Run once to initialize widgets
awful.spawn.easy_async_with_shell(check_script, function (stdout)
  check_bluetooth(stdout)
end)

-- Start monitoring process
helpers.start_monitor(monitor_script, { stdout = check_bluetooth })
