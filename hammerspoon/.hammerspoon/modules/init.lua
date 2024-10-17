--
-- init.lua
-- init modules
--

local config = require("configs")

require("modules.ipc")
require("modules.expose")

if config.wm.mode == "yabai" then
  require("modules.layouts")
  require("modules.spaces")
end

require("modules.display")
require("modules.cheatsheet")
require("modules.floating_terminal")
