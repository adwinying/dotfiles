--
-- hammerspoon.lua
-- hammerspoon basic keybindings
--

local hyper = require("modules.hyper")

-- =============================================================================
-- Definitions
-- =============================================================================

-- reload configs
hyper:bind({ "shift" }, "r", function ()
  hs.reload()
  hs.notify.show("Configs reloaded.", "", "")
end)

-- toggle console
hyper:bind({ "shift" }, "t", function ()
  hs.console.clearConsole()
  hs.toggleConsole()
end)
