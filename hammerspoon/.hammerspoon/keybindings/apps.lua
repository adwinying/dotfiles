--
-- spawn.lua
-- App spawning related keybindings
--

local configs = require("configs")
local hyper = require("modules.hyper")

-- =============================================================================
-- Definitions
-- =============================================================================

-- terminal
hyper:bind({}, "return", function ()
  hs.application.launchOrFocus(configs.apps.terminal)
end)

-- browser
hyper:bind({}, "b", function ()
  hs.application.launchOrFocus(configs.apps.browser)
end)
