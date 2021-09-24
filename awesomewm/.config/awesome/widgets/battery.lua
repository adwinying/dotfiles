--
-- battery.lua
-- battery status widget
--

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local keys = require("keys")

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
-- Definition
-- ========================================

-- define buttons
local buttons = function (screen)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      function() awful.spawn(apps.power_manager) end
    )
  )
end


-- get battery status
local get_battery_status = function (batt_stats)
  local status_count = {}
  local status_priority = {
    "Charging",
    "Full",
    "Discharging",
    "Unknown",
  }

  for _, stat in ipairs(batt_stats) do
    local status = stat.status
    status_count[status] = (status_count[status] or 0) + 1
  end

  for _, stat in ipairs(status_priority) do
    if status_count[stat] ~= nil then
      return stat
    end
  end

  return "Unknown"
end


-- get battery percentage
local get_battery_percentage = function (batt_stats)
  local charge = 0
  local capacity = 0

  for _, stat in ipairs(batt_stats) do
    charge = charge + stat.percentage * stat.capacity
    capacity = capacity + stat.capacity
  end

  return charge / capacity
end


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


-- get battery icon
local get_battery_icon = function (percentage, status)
  if percentage == nil then return icons_path .. "battery.svg" end

  local icon_name = "battery"

  local rounded_charge = math.floor(percentage / 10) * 10

  if status == "Charging" or status == "Full" then
    icon_name = icon_name .. "-charging"
  end

  if rounded_charge == 0 then
    icon_name = icon_name .. "-outline"
  elseif rounded_charge ~= 100 then
    icon_name = icon_name .. "-" .. rounded_charge
  end

  return icons_path .. icon_name .. ".svg"
end


-- update widget
local last_battery_check = os.time()
local update_widget = function (widget, stats, summary)
  local percentage = get_battery_percentage(stats)
  local status = get_battery_status(stats)

  local seconds_since_last_check = os.difftime(os.time(), last_battery_check) 

  if is_battery_low(percentage, status)
    and seconds_since_last_check > low_battery_reminder_interval then
    last_battery_check = os.time()

    notify_low_battery()
  end

  widget.image = get_battery_icon(percentage, status)
  widget.tooltip.text = string.gsub(summary, "\n$", "")

  collectgarbage("collect")
end


-- create widget instance
local create_widget = function (screen)
  local widget = wibox.widget {
    image = get_battery_icon(),
    widget = wibox.widget.imagebox,
  }
  awesome.connect_signal("daemon::battery", function(...)
    update_widget(widget, ...)
  end)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons(screen))

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Battery status unknown"

  return container
end

return create_widget
