--
-- taglist.lua
-- taglist component
--

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require('awful')
local gears = require("gears")
local wibox = require('wibox')
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local keys = require("keys")

-- define taglist button behaviour
local buttons = gears.table.join(
  awful.button(
    {}, 1,
    function (t) t:view_only() end
  ),

  awful.button(
    { keys.modkey }, 1,
    function (t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end
  ),

  awful.button(
    {}, 3,
    function (t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end
  ),

  awful.button(
    { keys.modkey }, 3,
    function (t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end
  ),

  awful.button(
    { }, 4,
    function (t) awful.tag.viewprev(t.screen) end
  ),

  awful.button(
    { }, 5,
    function (t) awful.tag.viewnext(t.screen) end
  )
)


-- determine icon to show for each tag
local update_tag_icon = function (widget, tag, index, taglist)
  if tag.selected then
    widget.text = beautiful.taglist_icon_focus
  elseif tag.urgent then
    widget.text = beautiful.taglist_icon_urgent
  elseif #tag:clients() > 0 then
    widget.text = beautiful.taglist_icon_occupied
  else
    widget.text = beautiful.taglist_icon_empty
  end
end

-- create taglist widget instance
local create_widget = function (screen)
  return awful.widget.taglist {
    screen = screen,
    filter = awful.widget.taglist.filter.all,
    layout = wibox.layout.fixed.horizontal,
    spacing = beautiful.taglist_spacing,
    widget_template = {
      widget = wibox.widget.textbox,
      text = "asdf",
      visible = true,
      valign = "center",
      align = "center",
      create_callback = update_tag_icon,
      update_callback = update_tag_icon,
    },
    buttons = buttons,
  }
end

return create_widget
