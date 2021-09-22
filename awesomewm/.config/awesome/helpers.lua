--
-- helpers.lua
-- helper functions
--

local awful = require("awful")
local beautiful = require("beautiful")

local helpers = {}

-- When layout is max remove gaps
helpers.set_gaps = function (screen, tag)
  local layout = tag.layout
  local topbar = screen.topbar

  if (layout == awful.layout.suit.max) then
    tag.gap = 0
    topbar.x = screen.geometry.x
    topbar.y = screen.geometry.y
    topbar.width = screen.geometry.width
    topbar:struts { top = beautiful.topbar_height }
  else
    tag.gap = beautiful.useless_gap
    topbar.x = screen.geometry.x + beautiful.topbar_margin * 2
    topbar.y = screen.geometry.y + beautiful.topbar_margin * 2
    topbar.width = screen.geometry.width - beautiful.topbar_margin * 4
    topbar:struts { top = beautiful.topbar_height + beautiful.topbar_margin * 2 }
  end
end

return helpers
