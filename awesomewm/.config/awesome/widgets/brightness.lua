--
-- brightness.lua
-- brightness widget
--

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local helpers = require("helpers")
local keys = require("keys")

-- ========================================
-- Config
-- ========================================

-- icons path
local icons_path = beautiful.icons_path .. "brightness/"


-- ========================================
-- Definition
-- ========================================

-- define buttons
local buttons = function (screen)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      -- Toggle redshift
      function() awful.spawn.with_shell("pkill -USR1 redshift-gtk") end
    ),
    awful.button(
      {}, keys.rightclick,
      function() helpers.change_brightness(100) end
    ),
    awful.button(
      {}, keys.scrolldown,
      function() helpers.change_brightness(1) end
    ),
    awful.button(
      {}, keys.scrollup,
      function() helpers.change_brightness(-1) end
    )
  )
end


-- update widget
local update_widget = function (widget, percentage)
  local icon_name

  if percentage <= 30 then
    icon_name = "brightness_low"
  elseif percentage > 30 and percentage <= 60 then
    icon_name = "brightness_medium"
  elseif percentage > 60 then
    icon_name = "brightness_high"
  end

  widget.image = icons_path .. icon_name .. ".svg"
  widget.tooltip.text = string.format("Brightness is at %s%%", percentage)
end


-- create widget instance
local create_widget = function (screen)
  local widget = wibox.widget {
    image = icons_path .. "brightness_medium.svg",
    widget = wibox.widget.imagebox,
  }
  awesome.connect_signal("daemon::brightness::percentage", function (...)
    update_widget(widget, ...)
  end)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons(screen))

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Brightness status unknown"

  return container
end

return create_widget
