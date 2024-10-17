--
-- display.lua
-- display related functions
--

local config = require("configs").display

Display = {}

Display.is_docked = nil
function Display:update_is_docked ()
  self.is_docked = false

  for _, screen in ipairs(hs.screen.allScreens()) do
    if screen:name() == config.dock_display then
      self.is_docked = true
    end
  end
end

Display.on_docked_callbacks = {}
function Display:on_docked (callback)
  table.insert(self.on_docked_callbacks, callback)
end

Display.on_undocked_callbacks = {}
function Display:on_undocked (callback)
  table.insert(self.on_undocked_callbacks, callback)
end

function Display:on_screen_changed ()
  local old_state = self.is_docked
  self:update_is_docked()
  local new_state = self.is_docked

  if old_state == new_state then return end

  if self.is_docked then
    for _, callback in ipairs(self.on_docked_callbacks) do callback() end
  else
    for _, callback in ipairs(self.on_undocked_callbacks) do callback() end
  end
end

function Display:init ()
  self:update_is_docked()

  hs.screen.watcher.newWithActiveScreen(
    function () self:on_screen_changed() end
  ):start()
end

Display:init()
Display:on_docked(function () hs.reload() end)
Display:on_undocked(function () hs.reload() end)
