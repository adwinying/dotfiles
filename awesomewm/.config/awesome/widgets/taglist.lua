--
-- taglist.lua
-- taglist component
--

local awful = require('awful')
local gears = require("gears")
local wibox = require('wibox')
local beautiful = require("beautiful")

local keys = require("keys")
local icons_path = beautiful.icons_path .. "taglist/"

-- define taglist buttons
local buttons = function (screen)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      function (t) t:view_only() end
    ),

    awful.button(
      { keys.modkey }, keys.leftclick,
      function (t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
      end
    ),

    awful.button(
      {}, keys.rightclick,
      function (t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
      end
    ),

    awful.button(
      { keys.modkey }, keys.rightclick,
      function (t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
      end
    ),

    awful.button(
      { }, keys.scrolldown,
      function (t) awful.tag.viewprev(t.screen) end
    ),

    awful.button(
      { }, keys.scrollup,
      function (t) awful.tag.viewnext(t.screen) end
    )
  )
end


-- determine icon to show for each tag
local update_tag_icon = function (widget, tag, index, taglist)
  local icon_name = "taglist_"

  if tag.selected then
    icon_name = icon_name .. "focus_"
  elseif tag.urgent then
    icon_name = icon_name .. "urgent_"
  else
    icon_name = icon_name .. "normal_"
  end

  if #tag:clients() > 0 then
    icon_name = icon_name .. "occupied"
  else
    icon_name = icon_name .. "empty"
  end

  widget.image = icons_path .. icon_name .. ".svg"
end

-- create taglist widget instance
local create_widget = function (screen)
  return wibox.widget {
    widget = wibox.container.margin,
    left = beautiful.clickable_container_padding_x,
    right = beautiful.clickable_container_padding_x,
    top = beautiful.clickable_container_padding_y,
    bottom = beautiful.clickable_container_padding_y,
    awful.widget.taglist {
      screen = screen,
      filter = awful.widget.taglist.filter.all,
      layout = wibox.layout.fixed.horizontal,
      spacing = beautiful.taglist_spacing,
      widget_template = {
        widget = wibox.widget.imagebox,
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
