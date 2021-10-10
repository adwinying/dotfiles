--
-- default.lua
-- Default Configs
--

local default_config = {}

-- =============================================================================
-- Default applications
-- =============================================================================

default_config.apps = {
  terminal = "iTerm",
  browser = "Brave Browser",
}

-- =============================================================================
-- Keybindings
-- =============================================================================

default_config.keybindings = {
  -- hyper key
  hyper = "f18",

  -- key to override hyper with
  hyper_override = "alt",
}

-- =============================================================================
-- Window manager
-- =============================================================================
default_config.wm = {
  -- menubar offset
  menubar_offset = 25,

  -- gap size
  gap_size = 9,

  -- resize step
  resize_step = 50,

  -- available layouts
  enabled_layouts = {
    "main-left",
    "monocle",
    "floating",
    "main-center",
  },

  -- default layout
  default_layout = "monocle",

  -- window rules
  rules = {
    -- don't tile Hammerspoon Console
    { app = 'Hammerspoon', title = 'Hammerspoon Console', tile = false },
  },
}

-- =============================================================================
-- Paths
-- =============================================================================

default_config.paths = {
  library = hs.configdir .. "/libraries",
}

return default_config
