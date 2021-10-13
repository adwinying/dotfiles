--
-- spaces.lua
-- current space indicator menu bar widget
--

local configs = require("configs")
local wm = require("modules.wm")

Spaces = {}

-- init params
Spaces.active_display_index = nil
Spaces.active_space_index = nil
Spaces.available_spaces = {}

-- init menubar
Spaces.menubar = hs.menubar.new()

function Spaces:set_icon ()
  local space_index = self.active_space_index or 'unknown'

  local icon = hs.image.imageFromPath(string.format(
    "%s/spaces/%s.pdf",
    configs.paths.icons,
    space_index
  )):setSize({
    w = configs.spaces.icon_size,
    h = configs.spaces.icon_size,
  }, true)

  self.menubar:setIcon(icon)
end

function Spaces:set_menu ()
  local display_index = self.active_display_index or 'unknown'
  local space_index = self.active_space_index or 'unknown'

  local menu = {
    { title = "Current Display: " .. display_index, disabled = true },
    { title = "Current Space: " .. space_index, disabled = true },
  }

  for _, space in ipairs(self.available_spaces) do
    table.insert(menu, {
      title = "Switch to Space " .. space,
      fn    = function () wm.api.space.focus(nil, space) end,
    })
  end

  self.menubar:setMenu(menu)
end

function Spaces:update_active_space (space)
  local display_info = wm.get_current_display() or nil

  self.active_display_index = display_info and display_info.index or nil
  self.active_space_index = space or wm.get_current_space().index or nil
  self.available_spaces = display_info and display_info.spaces or {}

  self:set_icon()
  self:set_menu()
end

Spaces:update_active_space()
