--
-- modifiers.lua
-- modifier keys-related settings
--

local FRemap = require("libraries.foundation_remapping")
local remapper = FRemap.new()

local configs = require("configs")
local keybindings = configs.keybindings


-- =============================================================================
-- Definitions
-- =============================================================================

-- Remap hyper_override to hyper key
remapper:remap(keybindings.hyper_override, keybindings.hyper):register()
