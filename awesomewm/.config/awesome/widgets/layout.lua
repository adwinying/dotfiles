--
-- layout.lua
-- display currently active layout
--

local wibox = require("wibox")
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
  local widget = wibox.widget {
    widget = wibox.layout.margin,
    top = dpi(7),
    bottom = dpi(7),
    awful.widget.layoutbox(screen),
  }

  local container = require("widgets.clickable_container")(widget)

  container:buttons(buttons(screen))

  return container
end

return create_widget
