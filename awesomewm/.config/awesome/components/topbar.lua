--
-- topbar.lua
-- topbar config
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

  s.mywibox = wibox({
    screen = s,
    visible = true,
    x = s.geometry.x + beautiful.topbar_margin * 2,
    y = s.geometry.y + beautiful.topbar_margin * 2,
    width = s.geometry.width - beautiful.topbar_margin * 4,
    height = beautiful.topbar_height,
  })
  s.mywibox:struts {
    top = beautiful.topbar_height + beautiful.topbar_margin * 2,
  }
  s.mywibox:setup {
    expand = "none",
    layout = wibox.layout.align.horizontal,
    -- Left widgets
    {
      widget = wibox.container.margin,
      left = beautiful.topbar_padding,
      right = beautiful.topbar_padding,
      {
        layout = wibox.layout.fixed.horizontal,
        s.mytaglist,
        require("widgets.task-list").create(s),
      },
    },
    -- Middle widgets
    {
      layout = wibox.layout.fixed.horizontal,
      require("widgets.calendar").create(s),
    },
    -- Right widgets
    {
      widget = wibox.container.margin,
      left = beautiful.topbar_padding,
      right = beautiful.topbar_padding,
      {
        layout = wibox.layout.fixed.horizontal,
        wibox.layout.margin(wibox.widget.systray(), dpi(5), dpi(5), dpi(5), dpi(5)),
        require("widgets.calendar").create(s),
        require("widgets.bluetooth"),
        require("widgets.network")(),
        require("widgets.battery"),
        {
          widget = wibox.layout.margin,
          top = dpi(5),
          bottom = dpi(5),
          require("widgets.layout-box"),
        },
      },
    },
  }
end)
