--
-- modules.lua
-- modules-related keybindings
--

local hyper = require("modules.hyper")

-- =============================================================================
-- Definitions
-- =============================================================================

-- activate expose
hyper:bind({}, "tab", function ()
  hs.expose.new(hs.window.filter.defaultCurrentSpace):toggleShow()
end)

-- activate cheatsheet
hyper:bind({ "shift" }, "/", function ()
  Cheatsheet:toggle()
end)
