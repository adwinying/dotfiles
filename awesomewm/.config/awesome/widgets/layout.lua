--
-- layout.lua
-- display currently active layout
--

local awful = require("awful")
local gears = require("gears")
local keys = require("keys")

-- define buttons
local buttons = function (screen)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      function() awful.layout.inc(1) end
    ),
    awful.button(
      {}, keys.rightclick,
      function() awful.layout.inc(-1) end
    ),
    awful.button(
      {}, keys.scrolldown,
      function() awful.layout.inc(1) end
    ),
    awful.button(
      {}, keys.scrollup,
      function() awful.layout.inc(-1) end
    )
  )
end


-- create widget instance
local create_widget = function (screen)
  local widget = awful.widget.layoutbox(screen)

  widget:buttons(buttons(screen))

  return widget
end

return create_widget
