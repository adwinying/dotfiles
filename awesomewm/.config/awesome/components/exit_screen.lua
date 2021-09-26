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


-- ========================================
-- Config
-- ========================================

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
    awesome.emit_signal("lock_screen::show")
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


-- ========================================
-- Logic
-- ========================================

-- Define a new class
local ExitScreen = {}
ExitScreen.__index = ExitScreen


-- Class constructor
function ExitScreen:new (screen)
  -- create new class instance
  local exit_screen = {}
  setmetatable(exit_screen, ExitScreen)

  -- screen instance
  exit_screen.screen = screen
  -- screen grabber instance
  exit_screen.screen_grabber = nil

  -- create widget components
  exit_screen.widget = exit_screen:create_widget()
  exit_screen:init_signals()

  return exit_screen
end


-- create the widget
function ExitScreen:create_widget ()
  -- Build buttons
  local button_widgets = {}
  for i, button in ipairs(buttons) do
    button_widgets[i] = self:create_button(
      button.caption,
      button.icon,
      commands[button.name]
    )
  end

  local widget = wibox {
    screen  = self.screen,
    x       = self.screen.geometry.x,
    y       = self.screen.geometry.y,
    height  = self.screen.geometry.height,
    width   = self.screen.geometry.width,
    visible = false,
    ontop   = true,
    type    = "splash",
    bg      = beautiful.exit_screen_bg,
  }

  widget:setup {
    layout = wibox.layout.align.vertical,
    expand = "none",
    nil,
    {
      layout = wibox.layout.align.horizontal,
      expand = "none",
      nil,
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.exit_screen_button_spacing,
        table.unpack(button_widgets),
      },
    },
  }

  -- Define mouse bindings
  widget:buttons(self.get_mousebindings())

  return widget
end


-- build button widget
function ExitScreen:create_button (name, icon, cmd)
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


-- Init signals
function ExitScreen:init_signals ()
  -- show the exit screen when signal is broadcasted
  awesome.connect_signal("exit_screen::show", function()
    if (awful.screen.focused() ~= self.screen) then return end

    self:show()
    self:activate_keybindings()
  end)

  -- hide the exit screen when signal is broadcasted
  awesome.connect_signal("exit_screen::hide", function()
    self:hide()
    self:deactivate_keybindings()
  end)
end


-- Get mousebindings
function ExitScreen:get_mousebindings ()
  return gears.table.join(
    -- Middle click - Hide exit_screen
    awful.button({}, keys.midclick, commands.cancel),

    -- Right click - Hide exit_screen
    awful.button({}, keys.rightclick, commands.cancel)
  )
end


-- Activate keybindings
function ExitScreen:activate_keybindings ()
  self.screen_grabber = awful.keygrabber.run(function(_, key, event)
    if event == "release" then return end

    local cmd = keybindings[key]

    if cmd ~= nil then cmd() end
  end)
end


-- Deactivate keybindings
function ExitScreen:deactivate_keybindings ()
  awful.keygrabber.stop(self.screen_grabber)
end


-- Show exit screen
function ExitScreen:show ()
  self.widget.visible = true
end


-- Hide exit screen
function ExitScreen:hide ()
  self.widget.visible = false
end


-- ========================================
-- Initialization
-- ========================================

awful.screen.connect_for_each_screen(function (s)
  s.exit_screen = ExitScreen:new(s)
end)
