--
-- init.lua
-- download libraries
--

local helpers = require("helpers")

-- foundation_remapping
-- https://github.com/hetima/hammerspoon-foundation_remapping
if not pcall(require, "libraries.foundation_remapping") then
  helpers.download_library(
    "foundation_remapping.lua",
    "https://raw.githubusercontent.com/hetima/hammerspoon-foundation_remapping/master/foundation_remapping.lua"
  )
end

-- hyperex
-- https://github.com/hetima/hammerspoon-hyperex
if not pcall(require, "libraries.hyperex") then
  helpers.download_library(
    "hyperex.lua",
    "https://raw.githubusercontent.com/hetima/hammerspoon-hyperex/master/hyperex.lua"
  )
end
