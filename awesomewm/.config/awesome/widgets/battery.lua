--
-- battery.lua
-- battery status widget
--

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local keys = require("keys")

-- ========================================
-- Config
-- ========================================

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
      function() awful.spawn(Apps.power_manager) end
    )
  )
end


-- get battery icon
local get_battery_icon = function (percentage, status)
  if percentage == nil then return icons_path .. "battery.svg" end

  local icon_name = "battery"

  local rounded_charge = math.ceil(percentage / 10) * 10

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
local update_widget = function (widget, _, stat, summary)
  widget.image = get_battery_icon(stat.percentage, stat.status)
  widget.tooltip.text = string.gsub(summary, "\n$", "")
end


-- create widget instance
local create_widget = function (screen)
  local widget = wibox.widget {
    image = get_battery_icon(),
    widget = wibox.widget.imagebox,
  }
  awesome.connect_signal("daemon::battery::status", function(...)
    update_widget(widget, ...)
  end)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons(screen))

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Battery status unknown"

  return container
end

return create_widget
