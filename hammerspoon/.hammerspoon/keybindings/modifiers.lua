--
-- modifiers.lua
-- modifier keys-related settings
--

local FRemap = require("libraries.foundation_remapping")
local remapper = FRemap.new()

local hyperex = require("libraries.hyperex")

local configs = require("configs")
local keybindings = configs.keybindings

if (not keybindings.enable_modifier_overrides) then return end

-- =============================================================================
-- Definitions
-- =============================================================================

-- Remap hyper_override to hyper key
remapper:remap(keybindings.hyper_override, keybindings.hyper):register()

-- Remap capslock to ctrl key
remapper:remap("capslock", "ctrl"):register()

-- Trigger escape when control key is pressed alone
hyperex.new("ctrl"):setEmptyHitKey("escape")

-- Trigger 英数 key when left command key is pressed alone
hyperex.new("cmd"):setEmptyHitKey(0x66)

-- Trigger かな key when right command key is pressed alone
hyperex.new("rightcmd"):setEmptyHitKey(0x68)
