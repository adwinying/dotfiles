--
-- hammerspoon.lua
-- hammerspoon basic keybindings
--

local helpers = require("helpers")
local hyper = require("modules.hyper")

-- =============================================================================
-- Definitions
-- =============================================================================

-- reload configs
hyper:bind({ "shift" }, "r", function ()
  hs.reload()
end)

-- toggle console
hyper:bind({ "shift" }, "t", function ()
  hs.console.clearConsole()
  hs.toggleConsole()

  -- focus next available window
  helpers.get_active_window(function (win) win:focus() end)
end)
