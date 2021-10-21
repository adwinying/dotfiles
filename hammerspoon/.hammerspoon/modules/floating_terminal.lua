--
-- floating_terminal.lua
-- floating terminal
--

local config = require("configs").floating_terminal
local wm = require("modules.wm")

FloatingTerm = {}

function FloatingTerm:get_instance ()
  return hs.appfinder.windowFromWindowTitle(config.title)
end

function FloatingTerm:spawn_instance ()
  os.execute(config.command)
end

function FloatingTerm:position_window ()
  local window = self:get_instance()

  if window == nil then return end

  -- move window to active space
  wm.api.window.space(window:id(), "mouse &")

  -- reposition window
  local display       = hs.screen.mainScreen()
  local display_frame = display:fullFrame()
  local x             = display_frame.x + display_frame.w * (1 - 0.35)
  local y             = display_frame.y

  wm.api.window.move(window:id(), string.format("abs:%s:%s &", x, y))

  -- resize window
  local width  = display_frame.w * 0.35
  local height = display_frame.h

  wm.api.window.resize(window:id(), string.format("abs:%s:%s &", width, height))
end

function FloatingTerm:show ()
  local instance = self:get_instance()

  if instance == nil then self:spawn_instance() end

  instance:unminimize()
end

function FloatingTerm:hide ()
  local instance = self:get_instance()

  if instance == nil then return end

  instance:focus()
  hs.eventtap.keyStroke({ "cmd" }, "h")
end

function FloatingTerm:toggle ()
  local instance = self:get_instance()

  if instance == nil then
    self:show()
  elseif hs.window.focusedWindow() ~= instance then
    instance:focus()
  else
    self:hide()
  end
end

hs.application.watcher.new(function (name, event)
  if name ~= config.name then return end

  if event ~= hs.application.watcher.launched then return end

  FloatingTerm:position_window()
end):start()
