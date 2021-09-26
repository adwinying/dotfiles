--
-- brightness.lua
-- brightness status notification
--

local naughty = require("naughty")
local beautiful = require("beautiful")

-- ========================================
-- Config
-- ========================================

local icons_path = beautiful.icons_path .. "brightness/"


-- ========================================
-- Logic
-- ========================================

-- Notify brightness change
local notify_brightness_change = function (percentage)
  return naughty.notify {
    icon = icons_path .. "brightness_notification.svg",
    title = "Brightness",
    text = string.format("Brightness is now at %s%%", percentage),
  }
end


-- ========================================
-- Initialization
-- ========================================

local notification

awesome.connect_signal("daemon::brightness::percentage", function (percentage)
  -- Remove existing notification
  if notification then naughty.destroy(notification) end

  notification = notify_brightness_change(percentage)
end)
