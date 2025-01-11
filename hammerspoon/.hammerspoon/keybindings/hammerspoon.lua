--
-- hammerspoon.lua
-- hammerspoon basic keybindings
--

local helpers = require("helpers")
local hyper = require("modules.hyper")
local config = require("configs")

-- =============================================================================
-- Definitions
-- =============================================================================

-- reload configs
hyper:bind({ "shift" }, "r", function ()
  if config.wm.mode == "aerospace" then
    hs.execute("aerospace reload-config")
  end

  if config.wm.mode == "yabai" then
    hs.execute("pkill yabai")
  end

  hs.reload()
end)

-- toggle console
hyper:bind({ "shift" }, "t", function ()
  hs.console.clearConsole()
  hs.toggleConsole()

  -- focus next available window
  helpers.get_active_window(function (win) win:focus() end)
end)
