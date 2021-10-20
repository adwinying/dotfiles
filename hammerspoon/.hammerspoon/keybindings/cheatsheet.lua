--
-- cheatsheet.lua
-- cheatsheet keybindings
--

local hyper = require("modules.hyper")

-- =============================================================================
-- Definitions
-- =============================================================================

-- activate cheatsheet
hyper:bind({ "shift" }, "/", function ()
  if Cheatsheet.is_active then
    Cheatsheet:hide()
  else
    Cheatsheet:show()
  end
end)
