--
-- tooltip.lua
-- attach tooltip to objects
--

local awful = require("awful")
local beautiful = require("beautiful")

local create_widget = function (objects)
  return awful.tooltip({
    objects = objects,
    text = "Tooltip",
    mode = "outside",
    margins_topbottom = beautiful.tooltip_padding_y,
    margins_leftright = beautiful.tooltip_padding_x,
  })
end

return create_widget
