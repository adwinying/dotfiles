--
-- bluetooth.lua
-- bluetooth widget
-- dependencies: bluez, bluez-utils
--

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local keys = require("keys")

-- ========================================
-- Config
-- ========================================

-- command to check bluetooth status
local command = "bluetoothctl --monitor list"
-- widget refresh interval
local interval = 60
-- icons path
local icons_path = beautiful.icons_path .. "bluetooth/"


-- ===================================================================
-- Definition
-- ===================================================================

-- define buttons
local buttons = function (screen)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      function() awful.spawn(apps.bluetooth_manager) end
    )
  )
end


-- update widget
local update_widget = function (widget, stdout)
  -- Check if there is bluetooth
  local has_bt = stdout:match("Controller") ~= nil
  local icon_name
  local status

  if has_bt then
    icon_name = "bluetooth.svg"
    status = "on"
  else
    icon_name = "bluetooth-off.svg"
    status = "off"
  end

  widget.image = icons_path .. icon_name
  widget.tooltip.text = "Bluetooth is " .. status

  collectgarbage("collect")
end


-- create widget instance
local create_widget = function (screen)
  local widget = wibox.widget {
    image = icons_path .. "bluetooth.svg",
    widget = wibox.widget.imagebox,
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
  widget.tooltip.text = "Bluetooth status unknown"

  return container
end

return create_widget
