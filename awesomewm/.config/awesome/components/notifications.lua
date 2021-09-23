--
-- notifications.lua
-- notification related configs
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
-- Error handling
-- ========================================

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors,
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end

    in_error = true
    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err),
    })
    in_error = false
  end)
end
