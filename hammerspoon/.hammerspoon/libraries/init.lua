--
-- init.lua
-- download libraries
--

local configs = require("configs")
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

-- hhtwm
-- https://github.com/szymonkaliski/hhtwm
if not pcall(require, "libraries.hhtwm") then
  helpers.download_library(
    "hhtwm/init.lua",
    "https://raw.githubusercontent.com/szymonkaliski/hhtwm/master/hhtwm/init.lua"
  )
  helpers.download_library(
    "hhtwm/layouts.lua",
    "https://raw.githubusercontent.com/szymonkaliski/hhtwm/master/hhtwm/layouts.lua"
  )

  -- rename internal require
  os.execute(
    "sed -i '' 's/hhtwm.layouts/libraries.hhtwm.layouts/' "
      .. configs.paths.library .. "/hhtwm/init.lua"
  )

  -- fallback when spaces not found
  os.execute(
    "sed -i '' 's/spacesLayout\\[spaceUUID\\]/spacesLayout[spaceUUID] or {}/' "
      .. configs.paths.library .. "/hhtwm/init.lua"
  )

  -- download required dependencies
  -- https://github.com/asmagill/hs._asm.undocumented.spaces
  os.execute(string.format(
    'curl "%s" | tar -C "%s" -xzf -',
    "https://raw.githubusercontent.com/asmagill/hs._asm.undocumented.spaces/master/spaces-v0.2.1.1-universal.tar.gz",
    hs.configdir
  ))
end
