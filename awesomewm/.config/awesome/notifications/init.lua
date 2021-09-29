--
-- init.lua
-- Initialize notifications
--

local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")


-- ========================================
-- Config
-- ========================================

naughty.config.padding = beautiful.screen_margin * 2
naughty.config.spacing = beautiful.screen_margin

naughty.config.defaults = {
  timeout      = 5,
  title        = "System Notification",
  text         = "",
  screen       = awful.screen.focused(),
  ontop        = true,
  margin       = beautiful.notification_margin,
  border_width = beautiful.notification_border_width,
  position     = "top_right",
  shape        = helpers.rrect,
}

naughty.config.presets.critical = {
  fg      = beautiful.notification_fg,
  bg      = beautiful.notification_bg_critical,
  timeout = 0,
}


-- ========================================
-- Initialization
-- ========================================

require("notifications.error")
require("notifications.network")
require("notifications.brightness")
require("notifications.volume")
require("notifications.battery")
require("notifications.player")
