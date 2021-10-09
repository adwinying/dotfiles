--
-- hyper.lua
-- Hyper key config
--

local configs = require("configs")
local keybindings = configs.keybindings

local hyper = hs.hotkey.modal.new({}, nil)

hyper.pressed = function ()
  hyper:enter()
end

hyper.released = function ()
  hyper:exit()
end

hs.hotkey.bind({}, keybindings.hyper, hyper.pressed, hyper.released)

return hyper
