--
-- default.lua
-- Default Configs
--

local default_config = {}

-- =============================================================================
-- Default applications
-- =============================================================================

default_config.apps = {
  terminal = "Ghostty",
  browser = "Arc",
  scratchpad_path = "open -na Ghostty.app --args --title=scratchpad",
}

-- =============================================================================
-- Keybindings
-- =============================================================================

default_config.keybindings = {
  -- enable/disable modifer overrides
  enable_modifier_overrides = true,

  -- enable/disable modifer overrides when docked
  enable_modifier_overrides_docked = false,

  -- hyper key
  hyper = "f18",

  -- key to override hyper with
  hyper_override = "alt",

  -- key to override hyper with when docked
  hyper_override_docked = nil,
}

-- =============================================================================
-- Window manager
-- =============================================================================

default_config.wm = {
  -- tiling wm to use (yabai|aerospace)
  mode = "aerospace",

  -- compatibility mode. Set to false if scripting additions is loaded
  compatibility_mode = true,

  -- aerospace path
  aerospace_path = "/opt/homebrew/bin/aerospace",

  -- yabai path
  yabai_path = "/usr/local/bin/yabai",

  -- units to move each time
  move_step = 50,

  -- units to resize each time
  resize_step = 50,
}

-- =============================================================================
-- Display
-- =============================================================================

default_config.display = {
  -- display names
  dock_display = "DELL U2723QX",
}

-- =============================================================================
-- Floating Terminal
-- =============================================================================

default_config.floating_terminal = {
  -- spawn command
  command = "open -na Ghostty.app --args --title=floatingterm &",

  -- terminal application name
  name = "ghostty",

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
