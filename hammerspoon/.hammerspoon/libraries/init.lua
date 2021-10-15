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

-- hs._asm.undocumented.spaces
-- https://github.com/asmagill/hs._asm.undocumented.spaces
if not pcall(require, "hs._asm.undocumented.spaces") then
  os.execute(string.format(
    'curl "%s" | tar -C "%s" -xzf -',
    "https://raw.githubusercontent.com/asmagill/hs._asm.undocumented.spaces/master/spaces-v0.2.1.1-universal.tar.gz",
    hs.configdir
  ))
end
