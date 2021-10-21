--
-- layouts.lua
-- current layout indicator menu bar widget
--

local configs = require("configs")
local wm = require("modules.wm")

Layouts = {}

-- init params
Layouts.available_layouts = { "bsp", "stack", "float" }
Layouts.active_layout = nil

-- init menubar
Layouts.menubar = hs.menubar.new()

function Layouts:set_icon ()
  local active_layout = self.active_layout or 'unknown'

  local icon = hs.image.imageFromPath(string.format(
    "%s/layouts/%s.pdf",
    configs.paths.icons,
    active_layout
  )):setSize({
    w = configs.layouts.icon_size,
    h = configs.layouts.icon_size,
  }, true)

  self.menubar:setIcon(icon)
end

function Layouts:set_menu ()
  local active_layout = self.active_layout or 'unknown'

  local menu = {
    { title = "Current Layout: " .. active_layout, disabled = true },
  }

  for _, layout in ipairs(self.available_layouts) do
    table.insert(menu, {
      title = string.format("Switch to %s layout", layout),
      fn = function ()
        wm.api.config("--space mouse layout " .. layout)
        self:update()
      end,
    })
  end

  self.menubar:setMenu(menu)
end

function Layouts:update (layout)
  self.active_layout = layout

  if self.active_layout == nil then
    local window = wm.get_current_window()

    if window == nil then
      self.active_layout = "unknown"
    elseif window.floating == 1 then
      self.active_layout = "float"
    else
      self.active_layout = wm.get_current_space().type
    end
  end

  self:set_icon()
  self:set_menu()
end

Layouts:update()
