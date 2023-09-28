--
-- default.lua
-- Default Configs
--

local default_config = {}

-- =============================================================================
-- Default applications
-- =============================================================================

default_config.apps = {
  terminal = "Alacritty",
  browser = "Arc",
  scratchpad_path = "/usr/local/bin/alacritty --title scratchpad",
}

-- =============================================================================
-- Keybindings
-- =============================================================================

default_config.keybindings = {
  -- enable/disable modifer overrides
  enable_modifier_overrides = true,

  -- hyper key
  hyper = "f18",

  -- key to override hyper with
  hyper_override = "alt",
}

-- =============================================================================
-- Window manager
-- =============================================================================

default_config.wm = {
  -- compatibility mode. Set to false if scripting additions is loaded
  compatibility_mode = true,

  -- yabai path
  yabai_path = "/usr/local/bin/yabai",

  -- units to move each time
  move_step = 50,

  -- units to resize each time
  resize_step = 50,
}

-- =============================================================================
-- Floating Terminal
-- =============================================================================

default_config.floating_terminal = {
  -- spawn command
  command = "/usr/local/bin/alacritty --title floatingterm &",

  -- terminal application name
  name = "alacritty",

  -- window title
  title = "floatingterm",
}

-- =============================================================================
-- Spaces menu bar widget
-- =============================================================================

default_config.spaces = {
  -- icon_size
  icon_size = 21,
}

-- =============================================================================
-- Layouts menu bar widget
-- =============================================================================

default_config.layouts = {
  -- icon_size
  icon_size = 20,
}

-- =============================================================================
-- Paths
-- =============================================================================

default_config.paths = {
  library = hs.configdir .. "/libraries",
  icons   = hs.configdir .. "/icons",
}

return default_config
