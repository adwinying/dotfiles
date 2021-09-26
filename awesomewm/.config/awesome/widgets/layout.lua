--
-- layout.lua
-- display currently active layout
--

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local keys = require("keys")
local beautiful = require("beautiful")

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


-- update widget
local update_widget = function (widget, tag)
  local layout = tag.layout
  local icon_name = "layout_" .. layout.name

  widget.image = beautiful[icon_name]
  widget.tooltip.text = layout.name
end


-- create widget instance
local create_widget = function (screen)
  local widget = wibox.widget {
    widget = wibox.widget.imagebox,
    resize = true,
  }

  tag.connect_signal("property::layout", function(t)
    update_widget(widget, t)
  end)
  tag.connect_signal("property::selected", function(t)
    update_widget(widget, t)
  end)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons(screen))

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Layout unknown"

  return container
end

return create_widget
