-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears   = require("gears")
local awful   = require("awful")
local helpers = require("helpers")

local config_dir = gears.filesystem.get_configuration_dir()

-- ========================================
-- User Config
-- ========================================

-- define default apps
apps = {
  terminal          = "st",
  launcher          = "rofi -modi drun,run,window,ssh -show drun -theme nord",
  volume_manager    = "pavucontrol",
  network_manager   = "nm-connection-editor",
  power_manager     = "xfce4-power-manager",
  bluetooth_manager = "blueman-manager",
  screenshot        = "maim",
  filebrowser       = "thunar",
}

-- network interfaces
network_interfaces = {
  wlan = "wlp3s0",
  lan = "enp0s25",
}

-- layouts
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.max,
}

-- tag configs
tags = {
  { name = "main" , layout = awful.layout.layouts[1] },
  { name = "web"  , layout = awful.layout.layouts[1] },
  { name = "code" , layout = awful.layout.layouts[1] },
  { name = "chat" , layout = awful.layout.layouts[1] },
  { name = "media", layout = awful.layout.layouts[1] },
}

-- run these apps on start up
local run_on_start_up = {
  "picom",
  "feh --bg-scale " .. config_dir .. "/wallpapers/pe.jpg",
  "ibus-daemon -drx",
}


-- ========================================
-- Visualizations
-- ========================================

-- Load theme vars
local beautiful = require("beautiful")
beautiful.init(config_dir .. "theme.lua")


-- ========================================
-- Initialization
-- ========================================

-- Run all apps listed on start up
for _, app in ipairs(run_on_start_up) do
  local findme = app
  local firstspace = app:find(" ")
  if firstspace then
    findme = app:sub(0, firstspace - 1)
  end

  awful.spawn.with_shell(string.format(
    "echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -",
    findme,
    app
  ), false)
end

-- Start daemons
require("daemons")

-- Load notifications
require("notifications")

-- Load components
require("components")


-- ========================================
-- Tags
-- ========================================

local tag_names = {}
local tag_layouts = {}

for i, tag in ipairs(tags) do
  tag_names[i] = tag.name
  tag_layouts[i] = tag.layout
end

-- Each screen has its own tag table.
awful.screen.connect_for_each_screen(function(s)
  awful.tag(tag_names, s, tag_layouts)
end)

-- Remove gaps if layout is set to max
tag.connect_signal("property::layout", function(t)
  helpers.set_gaps(t.screen, t)
end)
-- Layout might change in different tag
-- so update again when switched to another tag
tag.connect_signal("property::selected", function(t)
  helpers.set_gaps(t.screen, t)
end)


-- ========================================
-- Keybindings
-- ========================================

local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)


-- ========================================
-- Rules
-- ========================================

local rules = require("rules")
awful.rules.rules = rules


-- ========================================
-- Clients
-- ========================================

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  if not awesome.startup then
    awful.client.setslave(c)
  end

  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end

  -- Set rounded corners for windows
  c.shape = helpers.rrect
end)

-- Set border color of focused client
client.connect_signal("focus", function (c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function (c)
  c.border_color = beautiful.border_normal
end)

-- Focus clients under mouse
require("awful.autofocus")
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)


-- ========================================
-- Misc.
-- ========================================

-- Reload config when screen geometry change
screen.connect_signal("property::geometry", awesome.restart)


-- Garbage collcetion for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
