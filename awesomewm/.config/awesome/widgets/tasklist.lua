--
-- tasklist.lua
-- tasklist component
--

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require("beautiful")

local keys = require("keys")

-- define tasklist buttons
local buttons = function (screen)
  return gears.table.join(
    -- Restore minimized
    awful.button(
      {}, keys.leftclick,
      function ()
        local c = awful.client.restore()
        if c then client.focus = c end
      end
    ),

    -- Close
    awful.button(
      {}, keys.midclick,
      function () 
        if client.focus ~= nil then client.focus:kill() end
      end
    ),

    -- Minimize
    awful.button(
      {}, keys.rightclick,
      function () 
        if client.focus ~= nil then client.focus.minimized = true end
      end
    ),

    -- Cycle clients
    awful.button(
      {}, keys.scrollup,
      function () awful.client.focus.byidx(-1) end
    ),
    awful.button(
      {}, keys.scrolldown,
      function () awful.client.focus.byidx(1) end
    )
  )
end

-- get minimized clients
local get_minimized_clients = function (screen)
  local clients = {}

  for _, c in ipairs(screen.clients) do
    if not (
      c.skip_taskbar
      or c.hidden
      or c.type == "splash"
      or c.type == "dock"
      or c.type == "desktop"
    ) and c.minimized
    and awful.widget.tasklist.filter.currenttags(c, awful.screen.focused()) then
      table.insert(clients, c)
    end
  end

  return clients
end

-- get hidden/visible client counts
local get_clients_status = function (screen)
  local visible_clients = screen.clients
  local hidden_clients  = get_minimized_clients(screen)

  return string.format(
    "%s %s %s %s",
    beautiful.tasklist_icon_visible,
    #visible_clients,
    beautiful.tasklist_icon_hidden,
    #hidden_clients
  )
end

-- update widget info
local update_widget = function (widget, screen)
  widget.markup = get_clients_status(screen)
end

-- create taglist widget instance
local create_widget = function (screen)
  local widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "tasklist_widget",
    valign = "center",
    align = "center",
  }

  client.connect_signal("unmanage", function (c)
    update_widget(widget, screen)
  end)
  client.connect_signal("manage", function (c)
    update_widget(widget, screen)
  end)
  client.connect_signal("untagged", function (c)
    update_widget(widget, screen)
  end)
  client.connect_signal("property::minimized", function (c)
    update_widget(widget, screen)
  end)
  awful.tag.attached_connect_signal(s, "property::selected", function ()
    update_widget(widget, screen)
  end)

  return widget
end

return create_widget

