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
  hs.execute('open -na ' .. configs.apps.terminal)
end)

-- browser
hyper:bind({}, "b", function ()
  BrowserSpaces:focus()
end)

-- scratchpad
hyper:bind({}, "v", function ()
  os.execute(configs.apps.scratchpad_path .. " -e bash -c \"~/.dotfiles/scripts/scratchpad.sh\" &")
end)
