--
-- default.lua
-- Default Configs
--

local default_config = {}

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
-- Paths
-- =============================================================================

default_config.paths = {
  library = hs.configdir .. "/libraries",
}

return default_config
