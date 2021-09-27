--
-- bluetooth.lua
-- bluetooth widget
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
local icons_path = beautiful.icons_path .. "bluetooth/"


-- ========================================
-- Definition
-- ========================================

-- define buttons
local buttons = function (screen)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      function() awful.spawn(Apps.bluetooth_manager) end
    )
  )
end


-- update widget
local update_widget = function (widget, active)
  local icon_name
  local status

  if active then
    icon_name = "bluetooth.svg"
    status = "on"
  else
    icon_name = "bluetooth-off.svg"
    status = "off"
  end

  widget.image = icons_path .. icon_name
  widget.tooltip.text = "Bluetooth is " .. status
end


-- create widget instance
local create_widget = function (screen)
  local widget = wibox.widget {
    image = icons_path .. "bluetooth.svg",
    widget = wibox.widget.imagebox,
  }
  awesome.connect_signal("daemon::bluetooth::status", function (...)
    update_widget(widget, ...)
  end)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons(screen))

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Bluetooth status unknown"

  return container
end

return create_widget
