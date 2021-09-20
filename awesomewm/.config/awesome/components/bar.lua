--
-- bar.lua
-- statusbar config
--

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local keys = require("keys")

awful.screen.connect_for_each_screen(function (s)
  s.mypromptbox = awful.widget.prompt()

  s.mytaglist = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    layout = wibox.layout.fixed.horizontal,
    -- widget_template = {
    --   widget = wibox.widget.imagebox,
    -- },
    buttons = keys.taglist_buttons,
  }

  s.mywibox = awful.wibar({
    position = beautiful.wibar_position,
    screen = s,
    width = beautiful.wibar_width,
    height = beautiful.wibar_height
  })
  s.mywibox:setup {
    expand = "none",
    layout = wibox.layout.align.horizontal,
    -- Left widgets
    {
      layout = wibox.layout.fixed.horizontal,
      s.mytaglist,
      require("widgets.task-list").create(s),
    },
    -- Middle widgets
    {
      layout = wibox.layout.fixed.horizontal,
      require("widgets.calendar").create(s),
    },
    -- Right widgets
    {
      layout = wibox.layout.fixed.horizontal,
      wibox.layout.margin(wibox.widget.systray(), dpi(5), dpi(5), dpi(5), dpi(5)),
      require("widgets.calendar").create(s),
      require("widgets.bluetooth"),
      require("widgets.network")(),
      require("widgets.battery"),
      wibox.layout.margin(require("widgets.layout-box"), dpi(5), dpi(5), dpi(5), dpi(5)),
    },
  }
end)
