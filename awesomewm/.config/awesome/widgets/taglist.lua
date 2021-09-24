--
-- taglist.lua
-- taglist component
--

local awful = require('awful')
local gears = require("gears")
local wibox = require('wibox')
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local keys = require("keys")

-- define taglist buttons
local buttons = function (screen)
  return gears.table.join(
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
end


-- determine icon to show for each tag
local update_tag_icon = function (widget, tag, index, taglist)
  if tag.selected and #tag:clients() > 0 then
    widget.markup = string.format(
      '<span fgcolor="%s">%s</span>',
      beautiful.taglist_fg_focus,
      beautiful.taglist_icon_occupied
    )
  elseif tag.selected then
    widget.markup = string.format(
      '<span fgcolor="%s">%s</span>',
      beautiful.taglist_fg_focus,
      beautiful.taglist_icon_empty
    )
  elseif tag.urgent then
    widget.markup = string.format(
      '<span fgcolor="%s">%s</span>',
      beautiful.taglist_fg_urgent,
      beautiful.taglist_icon_urgent
    )
  elseif #tag:clients() > 0 then
    widget.markup = string.format(
      '<span fgcolor="%s">%s</span>',
      beautiful.taglist_fg_occupied,
      beautiful.taglist_icon_occupied
    )
  else
    widget.markup = string.format(
      '<span fgcolor="%s">%s</span>',
      beautiful.taglist_fg_empty,
      beautiful.taglist_icon_empty
    )
  end
end

-- create taglist widget instance
local create_widget = function (screen)
  return wibox.widget {
    widget = wibox.container.margin,
    left = beautiful.clickable_container_padding_x,
    right = beautiful.clickable_container_padding_x,
    awful.widget.taglist {
      screen = screen,
      filter = awful.widget.taglist.filter.all,
      layout = wibox.layout.fixed.horizontal,
      spacing = beautiful.taglist_spacing,
      widget_template = {
        widget = wibox.widget.textbox,
        text = "taglist_widget",
        valign = "center",
        align = "center",
        create_callback = update_tag_icon,
        update_callback = update_tag_icon,
      },
      buttons = buttons(screen),
    }
  }
end

return create_widget
