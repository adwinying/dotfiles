--
-- clickable_container.lua
-- eyecandy effect when hovering over widgets
--

local wibox = require('wibox')
local beautiful = require("beautiful")

-- create widget instance
local create_widget = function (widget)
  local old_cursor, old_wibox

  local container = wibox.widget {
    widget = wibox.container.background,
    {
      widget = wibox.container.margin,
      top = beautiful.clickable_container_padding_y,
      bottom = beautiful.clickable_container_padding_y,
      left = beautiful.clickable_container_padding_x,
      right = beautiful.clickable_container_padding_x,
      widget,
    },
  }

  container:connect_signal('mouse::enter', function()
    container.bg = '#ffffff11'
    local w = _G.mouse.current_wibox
    if w then
      old_cursor, old_wibox = w.cursor, w
      w.cursor = 'hand1'
    end
  end)
  container:connect_signal('mouse::leave', function()
    container.bg = '#ffffff00'
    if old_wibox then
      old_wibox.cursor = old_cursor
      old_wibox = nil
    end
  end)
  container:connect_signal('button::press', function()
    container.bg = '#ffffff22'
  end)
  container:connect_signal('button::release', function()
    container.bg = '#ffffff11'
  end)

  return container
end

return create_widget
