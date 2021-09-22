--
-- topbar.lua
-- topbar config
--

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

awful.screen.connect_for_each_screen(function (s)
  s.topbar = wibox({
    screen = s,
    visible = true,
    x = s.geometry.x + beautiful.topbar_margin * 2,
    y = s.geometry.y + beautiful.topbar_margin * 2,
    width = s.geometry.width - beautiful.topbar_margin * 4,
    height = beautiful.topbar_height,
  })
  s.topbar:struts {
    top = beautiful.topbar_height + beautiful.topbar_margin * 2,
  }
  s.topbar:setup {
    layout = wibox.layout.align.horizontal,
    expand = "none",
    -- Left widgets
    {
      widget = wibox.container.margin,
      left = beautiful.topbar_padding,
      right = beautiful.topbar_padding,
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.topbar_spacing,
        require("widgets.taglist")(s),
        require("widgets.task-list").create(s),
      },
    },

    -- Middle widgets
    {
      layout = wibox.layout.fixed.horizontal,
    },

    -- Right widgets
    {
      widget = wibox.container.margin,
      left = beautiful.topbar_padding,
      right = beautiful.topbar_padding,
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.topbar_spacing,
        {
          widget = wibox.layout.margin,
          top = dpi(7),
          bottom = dpi(7),
          wibox.widget.systray(),
        },
        require("widgets.bluetooth"),
        require("widgets.network")(),
        require("widgets.battery"),
        require("widgets.calendar").create(s),
        {
          widget = wibox.layout.margin,
          top = dpi(7),
          bottom = dpi(7),
          require("widgets.layout-box"),
        },
      },
    },
  }
end)