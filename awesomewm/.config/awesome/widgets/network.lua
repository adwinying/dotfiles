--
-- network.lua
-- simple network widget
-- dependencies: iproute2, iw
--

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local keys = require("keys")

-- ========================================
-- Config
-- ========================================

-- Icons path
local icons_path = beautiful.icons_path .. "network/"


-- ========================================
-- Definition
-- ========================================

-- define buttons
local buttons = function (screen)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      function() awful.spawn(Apps.network_manager) end
    )
  )
end


-- update wireless status
local update_wireless_status = function (widget, interface, healthy, essid, bitrate, strength)
  local status = healthy
    and "Connected to internet"
    or  "Connected but no internet!"

  local strength_level = math.ceil(strength * 0.04)
  local icon_name = healthy
    and string.format("wifi-strength-%s", strength_level)
    or  string.format("wifi-strength-%s-alert", strength_level)

  widget.image = icons_path .. icon_name .. ".svg"
  widget.tooltip.markup = string.format(
    "<b>%s</b>"
    .. "\nESSID: <b>%s</b>"
    .. "\nInterface: <b>%s</b>"
    .. "\nStrength: <b>%s%%</b>"
    .. "\nBitrate: <b>%s</b>",
    status,
    essid,
    interface,
    strength,
    bitrate
  )
end


-- update wired status
local update_wired_status = function (widget, interface, healthy)
  local status = healthy
    and "Connected to internet"
    or "Connected but no internet!"

  local icon_name = healthy
    and "wired"
    or "wired-alert"

  widget.image = icons_path .. icon_name .. ".svg"
  widget.tooltip.markup = string.format(
    "<b>%s</b>"
    .. "\nInterface: <b>%s</b>",
    status,
    interface
  )
end


-- update disconnected status
local update_disconnected = function (widget, mode)
  local icon_name = nil

  if mode == "wireless" then
    icon_name = "wifi-strength-off"
  elseif mode == "wired" then
    icon_name = "wired-off"
  end

  widget.image = icons_path .. icon_name .. ".svg"
  widget.tooltip.text = "Network is currently disconnected"
end

-- create widget instance
local create_widget = function (screen)
  local widget = wibox.widget {
    image = icons_path .. 'loading.svg',
    widget = wibox.widget.imagebox,
  }

  awesome.connect_signal("daemon::network::status::wireless", function(...)
    update_wireless_status(widget, ...)
  end)
  awesome.connect_signal("daemon::network::status::wired", function(...)
    update_wired_status(widget, ...)
  end)
  awesome.connect_signal("daemon::network::disconnected::wireless", function()
    update_disconnected(widget, "wireless")
  end)
  awesome.connect_signal("daemon::network::disconnected::wired", function()
    update_disconnected(widget, "wired")
  end)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons(screen))

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Network status unknown"

  return container
end

return create_widget
