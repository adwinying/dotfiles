--
-- __      _____ _________ ___ ___ __  __
-- \ \    / / __|_  /_   _| __| _ \  \/  |
--  \ \/\/ /| _| / /  | | | _||   / |\/| |
--   \_/\_/ |___/___| |_| |___|_|_\_|  |_|
--

-- Pull in the wezterm API
local wezterm = require "wezterm"

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.font = wezterm.font "HackGenNerd Console"
config.font_size = 14.0

local scheme = wezterm.get_builtin_color_schemes()['nord']
scheme.background = '#171a20'
config.color_schemes = {
  nord = scheme,
}
config.color_scheme = "nord"

config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 25,
  right = 25,
  top = 25,
  bottom = 25,
}
config.window_close_confirmation = "NeverPrompt"

config.initial_cols = 160
config.initial_rows = 60
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
  { key = "q", mods = "CTRL", action = wezterm.action { SendString = "\x11" } },
}

config.use_ime = true

-- and finally, return the configuration to wezterm
return config
