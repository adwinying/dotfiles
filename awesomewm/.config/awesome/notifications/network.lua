--
-- network.lua
-- network status notification
--

local naughty = require("naughty")
local beautiful = require("beautiful")

-- ========================================
-- Config
-- ========================================

local icons_path = beautiful.icons_path .. "network/"


-- ========================================
-- Logic
-- ========================================

-- Notify wireless connected notification
local notify_connected_wireless = function(essid)
  naughty.notify {
    icon = icons_path .. "connected_notification.svg",
    title = "Connection Established",
    text = string.format("You are now connected to <b>%s</b>", essid),
  }
end


-- Notify wired connected notification
local notify_connected_wired = function(interface)
  naughty.notify {
    icon = icons_path .. "wired.svg",
    title = "Connection Established",
    text = string.format("Connected to internet with <b>%s</b>", interface),
  }
end


-- Notify wireless disconnected notification
local notify_disconnected_wireless = function()
  naughty.notify {
    icon = icons_path .. "wifi-strength-off.svg",
    title = "Disconnected",
    text = "Wi-Fi network has been disconnected",
  }
end


-- Notify wired disconnected notification
local notify_disconnected_wired = function()
  naughty.notify {
    icon = icons_path .. "wired-off.svg",
    title = "Disconnected",
    text = "Ethernet network has been disconnected",
  }
end


-- ========================================
-- Initialization
-- ========================================

awesome.connect_signal("daemon::network::connected::wireless", function (_, essid)
  notify_connected_wireless(essid)
end)

awesome.connect_signal("daemon::network::connected::wired", function (interface)
  notify_connected_wired(interface)
end)

awesome.connect_signal("daemon::network::disconnected::wireless", function ()
  notify_disconnected_wireless()
end)

awesome.connect_signal("daemon::network::disconnected::wired", function ()
  notify_disconnected_wired()
end)
