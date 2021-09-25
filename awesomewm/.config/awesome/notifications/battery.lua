--
-- battery.lua
-- battery status notification
--

local naughty = require("naughty")
local beautiful = require("beautiful")

-- ========================================
-- Config
-- ========================================

-- notify when battery is below certain amount
local low_battery_threshold = 15
-- re-notify low battery every x seconds
local low_battery_reminder_interval = 300
-- icons path
local icons_path = beautiful.icons_path .. "battery/"


-- ========================================
-- Logic
-- ========================================

-- check whether battery is low
local is_battery_low = function (percentage, status)
  return percentage >= 0
    and percentage < low_battery_threshold
    and status ~= "Charging"
end


-- show low battery notification
local notify_low_battery = function ()
  naughty.notify {
    preset = naughty.config.presets.critical,
    icon = icons_path .. "battery-outline.svg",
    timeout = 5,
    title = "Low Battery",
    text = "Time to plug in soon!",
  }
end


-- show charger plugged notification
local notify_charger_plugged = function ()
  naughty.notify {
    icon = icons_path .. "charger-plugged.svg",
    title = "AC Adapter",
    text = "AC Adapter plugged in.",
  }
end


-- show charger unplugged notification
local notify_charger_unplugged = function ()
  naughty.notify {
    icon = icons_path .. "charger-unplugged.svg",
    title = "AC Adapter",
    text = "AC Adapter unplugged.",
  }
end


-- ========================================
-- Initialization
-- ========================================

local last_battery_check = os.time()

awesome.connect_signal("daemon::battery::status", function(_, stat)
  local seconds_since_last_check = os.difftime(os.time(), last_battery_check)

  if is_battery_low(stat.percentage, stat.status)
    and seconds_since_last_check > low_battery_reminder_interval then
    last_battery_check = os.time()

    notify_low_battery()
  end
end)

awesome.connect_signal("daemon::charger::status", function(plugged)
  if plugged then
    notify_charger_plugged()
  else
    notify_charger_unplugged()
  end
end)
