--
-- exit.lua
-- exit screen component
--

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local keys = require("keys")


-- ===================================================================
-- Config
-- ===================================================================

-- icons path
local icons_path = beautiful.icons_path .. "exit_screen/"

-- buttons list
local buttons = {
  { name = "poweroff", caption = "Poweroff", icon = "exit_screen_poweroff" },
  { name = "reboot"  , caption = "Reboot"  , icon = "exit_screen_reboot"   },
  { name = "suspend" , caption = "Suspend" , icon = "exit_screen_suspend"  },
  { name = "logout"  , caption = "Logout"  , icon = "exit_screen_logout"   },
  { name = "lock"    , caption = "Lock"    , icon = "exit_screen_lock"     },
  { name = "cancel"  , caption = "Cancel"  , icon = "exit_screen_cancel"   },
}

-- callback function for each button
local commands = {
  poweroff = function ()
    awful.spawn.with_shell("poweroff")
  end,

  reboot = function ()
    awful.spawn.with_shell("reboot")
  end,

  suspend = function ()
    awesome.emit_signal("exit_screen::hide")
    awful.spawn.with_shell("systemctl suspend")
  end,

  logout = function ()
    awesome.quit()
  end,

  lock = function ()
    awesome.emit_signal("exit_screen::hide")
    awful.spawn.with_shell(Apps.lock)
  end,

  cancel = function ()
    awesome.emit_signal("exit_screen::hide")
  end,
}

-- map keybinds to functions
local keybindings = {
  p      = commands.poweroff,
  r      = commands.reboot,
  s      = commands.suspend,
  e      = commands.logout,
  l      = commands.lock,
  q      = commands.cancel,
  x      = commands.cancel,
  Escape = commands.cancel,
}

-- map mousebinds to function
local mousebindings = gears.table.join(
  -- Middle click - Hide exit_screen
  awful.button({}, keys.midclick, commands.cancel),

  -- Right click - Hide exit_screen
  awful.button({}, keys.rightclick, commands.cancel)
)


-- ===================================================================
-- Logic
-- ===================================================================

local exit_screen = {}

-- Activate keybindings
local activate_keybindings = function ()
  exit_screen.screen_grabber = awful.keygrabber.run(function(_, key, event)
    if event == "release" then return end

    local cmd = keybindings[key]

    if cmd ~= nil then cmd() end
  end)
end


-- Deactivate keybindings
local deactivate_keybindings = function ()
  awful.keygrabber.stop(exit_screen.screen_grabber)
end


-- Show exit screen
local show_exit_screen = function ()
  exit_screen.widget.visible = true
end


-- Hide exit screen
local hide_exit_screen = function ()
  exit_screen.widget.visible = false
end


-- build button widget
local build_button_widget = function (name, icon, cmd)
  local button = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = beautiful.exit_screen_caption_spacing,
    {
      id = "icon_wrapper",
      layout = wibox.layout.align.horizontal,
      expand = "none",
      nil,
      require("widgets.clickable_container")({
        widget = wibox.widget.imagebox,
        resize = true,
        image = icons_path .. icon .. ".svg",
        forced_height = beautiful.exit_screen_icon_size,
      }),
    },
    {
      widget = wibox.widget.textbox,
      text = name,
      align = "center",
      valign = "center",
    },
  }

  button.icon_wrapper.second:connect_signal("button::release", cmd)
  button.icon_wrapper.second:set_shape(helpers.rrect)

  return button
end


-- ===================================================================
-- Initialization
-- ===================================================================

local screen_geometry = awful.screen.focused().geometry

-- Create the widget
exit_screen.widget = wibox {
  x = screen_geometry.x,
  y = screen_geometry.y,
  visible = false,
  ontop = true,
  type = "splash",
  height = screen_geometry.height,
  width = screen_geometry.width,
  bg = beautiful.exit_screen_bg,
}

-- Build buttons
exit_screen.buttons = {}

for i, button in ipairs(buttons) do
  exit_screen.buttons[i] = build_button_widget(
    button.caption,
    button.icon,
    commands[button.name]
  )
end

-- Item placement
exit_screen.widget:setup {
  layout = wibox.layout.align.vertical,
  expand = "none",
  nil,
  {
    nil,
    {
      layout = wibox.layout.fixed.horizontal,
      spacing = beautiful.exit_screen_button_spacing,
      table.unpack(exit_screen.buttons),
      -- build_button_widget("Poweroff", "exit_screen_poweroff", commands.poweroff),
      -- build_button_widget("Reboot", "exit_screen_reboot",  commands.reboot),
      -- build_button_widget("Suspend", "exit_screen_suspend", commands.suspend),
      -- build_button_widget("Logout", "exit_screen_logout", commands.logout),
      -- build_button_widget("Lock", "exit_screen_lock", commands.lock),
      -- build_button_widget("Cancel", "exit_screen_cancel", commands.cancel),
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  nil,
}

-- Define mouse bindings
exit_screen.widget:buttons(mousebindings)

-- show the exit screen when signal is broadcasted
awesome.connect_signal("exit_screen::show", function()
  show_exit_screen()
  activate_keybindings()
end)

-- hide the exit screen when signal is broadcasted
awesome.connect_signal("exit_screen::hide", function()
  hide_exit_screen()
  deactivate_keybindings()
end)
