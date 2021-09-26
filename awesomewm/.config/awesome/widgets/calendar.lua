--
-- calendar.lua
-- clock/calendar widget
--

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- create widget instance
local create_widget = function (screen)
  -- Clock Widget
  local clock_widget = wibox.widget {
    widget = wibox.widget.textclock,
    format = "%a %b %d %R",
    refresh = 30,
  }

  -- Calendar Widget
  local month_calendar = awful.widget.calendar_popup.month {
    screen = screen,
    start_sunday = true,
    long_weekdays = true,
    spacing = beautiful.calendar_spacing,
    style_month = {
      padding = beautiful.calendar_padding,
    },
  }

  -- Attach calendar to clock_widget
  month_calendar:attach(clock_widget, "tc")

  return clock_widget
end

return create_widget
