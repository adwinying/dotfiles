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

-- command t ocheck battery status
local command = "acpi -i"
-- widget refresh interval
local interval = 60
-- notify when battery is below certain amount
local low_battery_threshold = 15
-- re-notify low battery every x seconds
local low_battery_reminder_interval = 300


-- ========================================
-- Definition
-- ========================================

-- define taglist buttons
local buttons = function (screen)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      function() awful.spawn(apps.power_manager) end
    )
  )
end


-- parse stdout from command
local parse_stdout = function(stdout)
  local battery_info = {}
  local capacities = {}

  for s in stdout:gmatch("[^\r\n]+") do
    local status, charge_str, time = string.match(s, ".+: (%a+), (%d?%d?%d)%%,?.*")
    if status ~= nil then
      table.insert(battery_info, {status = status, charge = tonumber(charge_str)})
    else
      local cap_str = string.match(s, ".+:.+last full capacity (%d+)")
      table.insert(capacities, tonumber(cap_str))
    end
  end

  local result = {}
  for i = 1, #battery_info, 1 do
    result[i] = {
      status = battery_info[i].status,
      charge = battery_info[i].charge,
      capacity = capacities[i],
    }
  end

  return result
end


-- get battery status
local get_battery_status = function (batt_stats)
  local charge = 0
  local status = "Unknown"

  for _, stat in ipairs(batt_stats) do
    if stat.charge >= charge then
      -- use most charged battery status
      -- this is arbitrary, and maybe another metric should be used
      status = stat.status
      charge = stat.charge
    end
  end

  return status
end


-- get battery percentage
local get_battery_percentage = function (batt_stats)
  local charge = 0
  local capacity = 0

  for _, stat in ipairs(batt_stats) do
    charge = charge + stat.charge * stat.capacity
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
    timeout = 5,
    title = "Low Battery",
    text = "Time to plug in soon!",
  }
end


-- get battery status markup
local get_battery_status_markup = function (percentage, status)
  local icon_name = "battery_icon_low"
  local icon_color = beautiful.battery_fg_normal

  if precentage ~= nil and is_battery_low(percentage, status) then
    icon_name = "battery_icon_low"
    icon_color = beautiful.battery_fg_urgent
  elseif status == "Charging" or status == "Full" then
    icon_name = "battery_icon_charging"
  elseif percentage ~= nil then
    icon_name = "battery_icon_" .. math.ceil(percentage / 10) * 10
  end

  return string.format(
    '<span fgcolor="%s">%s</span>',
    icon_color,
    beautiful[icon_name]
  )
end


-- update widget
local last_battery_check = os.time()
local update_widget = function (widget, stdout)
  local batt_stats = parse_stdout(stdout)
  local percentage = get_battery_percentage(batt_stats)
  local status = get_battery_status(batt_stats)

  local seconds_since_last_check = os.difftime(os.time(), last_battery_check) 

  if is_battery_low(percentage, status)
    and seconds_since_last_check > low_battery_reminder_interval then
    last_battery_check = os.time()

    notify_low_battery()
  end

  widget.markup = get_battery_status_markup(percentage, status)
  widget.tooltip.text = string.gsub(stdout, "\n$", "")

  collectgarbage("collect")
end


-- create widget instance
local create_widget = function (screen)
  local widget = wibox.widget {
    markup = get_battery_status_markup(),
    widget = wibox.widget.textbox,
  }

  local watched_widget = awful.widget.watch(
    command,
    interval,
    update_widget,
    widget
  )

  local container = require("widgets.clickable_container")(watched_widget)
  container:buttons(buttons(screen))

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Battery status unknown"

  return container
end

return create_widget
