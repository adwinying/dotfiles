--
-- volume.lua
-- volume status notification
--

local naughty = require("naughty")
local beautiful = require("beautiful")

-- ========================================
-- Config
-- ========================================

local icons_path = beautiful.icons_path .. "volume/"


-- ========================================
-- Logic
-- ========================================

-- Notify volume change
local notify_volume_change = function (percentage)
  return naughty.notify {
    icon = icons_path .. "volume_notification.svg",
    title = "Volume",
    text = string.format("Volume is now at %s%%", percentage),
  }
end


-- Notify volume muted
local notify_volume_muted = function ()
  return naughty.notify {
    icon = icons_path .. "volume_notification_muted.svg",
    title = "Volume",
    text = "Volume is now muted",
  }
end


-- ========================================
-- Initialization
-- ========================================

local notification

awesome.connect_signal("daemon::volume::percentage", function (percentage)
  -- Pavucontrol already show volume, so do nothing
  if client.focus and client.focus.class == "Pavucontrol" then return end

  -- Remove existing notification
  if notification then naughty.destroy(notification) end

  notification = notify_volume_change(percentage)
end)
awesome.connect_signal("daemon::volume::muted", function ()
  -- Pavucontrol already show volume, so do nothing
  if client.focus and client.focus.class == "Pavucontrol" then return end

  -- Remove existing notification
  if notification then naughty.destroy(notification) end

  notification = notify_volume_muted()
end)
