--
-- lock_screen.lua
-- lock screen component
--
-- Disclaimer:
-- This lock screen was not designed with security in mind.
-- There is no guarantee that it will protect you against someone
-- that wants to gain access to your computer.
--

local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local keys = require("keys")
local helpers = require("helpers")


-- ========================================
-- Config
-- ========================================

-- lua-pam path
local lib_path = "/usr/lib/lua-pam/?.so"


-- ========================================
-- Logic
-- ========================================

-- Define a new class
local LockScreen = {}
LockScreen.__index = LockScreen


-- Class constructor
function LockScreen:new (s)
  -- create new class instance
  local lock_screen = {}
  setmetatable(lock_screen, LockScreen)

  -- screen instance
  lock_screen.screen = s

  -- A dummy textbox needed to get user input.
  -- It will not be visible anywhere.
  lock_screen.textbox = wibox.widget.textbox()
  lock_screen.textbox.visible = true
  lock_screen.textbox.opacity = 0

  -- Track characters entered
  lock_screen.characters_entered = 0

  -- create widget components
  lock_screen.wrapper = lock_screen:create_wrapper()
  lock_screen.widget = nil

  -- init widget only for primary screen
  if s == screen.primary then
    lock_screen.widget = lock_screen:create_widget()
    lock_screen.wrapper:setup(lock_screen.widget)
  end

  -- init signals
  lock_screen:init_signals()

  return lock_screen
end


-- Create the lock screen wrapper
function LockScreen:create_wrapper ()
  local wrapper = wibox {
    screen  = self.screen,
    x       = self.screen.geometry.x,
    y       = self.screen.geometry.y,
    height  = self.screen.geometry.height,
    width   = self.screen.geometry.width,
    visible = false,
    ontop   = true,
    type    = "splash",
    bg      = beautiful.lock_screen_bg,
  }

  return wrapper
end

-- Create the lock screen widget
function LockScreen:create_widget ()
  return {
    -- Horizontal centering
    layout = wibox.layout.align.horizontal,
    expand = "none",
    nil,
    {
      -- Vertical centering
      layout = wibox.layout.align.vertical,
      expand = "none",
      nil,
      {
        layout       = wibox.layout.fixed.vertical,
        spacing      = beautiful.lock_screen_spacing_y,
        forced_width = beautiful.lock_screen_width,
        {
          layout = wibox.layout.align.horizontal,
          expand = "none",
          nil,
          {
            layout = wibox.layout.fixed.horizontal,
            spacing = beautiful.lock_screen_spacing_x,
            {
              widget        = wibox.widget.imagebox,
              image         = beautiful.lock_screen_title_icon,
              resize        = true,
              forced_height = beautiful.lock_screen_title_icon_size,
              forced_width  = beautiful.lock_screen_title_icon_size,
            },
            {
              layout = wibox.layout.align.vertical,
              expand = "none",
              nil,
              {
                widget = wibox.widget.textbox,
                font   = beautiful.lock_screen_title_font,
                text   = "Locked",
              },
            },
          },
        },
        {
          layout = wibox.layout.align.horizontal,
          expand = "none",
          nil,
          {
            layout        = wibox.layout.fixed.horizontal,
            spacing       = beautiful.lock_screen_dot_spacing,
            forced_height = beautiful.lock_screen_dot_size,
            table.unpack(self:create_dots()),
          },
        },
      },
    },
  }
end


-- Create dot
function LockScreen:create_dot ()
  return {
    widget        = wibox.widget.imagebox,
    image         = beautiful.lock_screen_dot_icon,
    resize        = true,
    forced_height = beautiful.lock_screen_dot_size,
    forced_width  = beautiful.lock_screen_dot_size,
  }
end


-- Create dots
function LockScreen:create_dots ()
  local dots = {}

  for i = 1, string.len(self.textbox.text) - 1 do
    dots[i] = self:create_dot()
  end

  return dots
end


-- Init signals
function LockScreen:init_signals ()
  -- show the lock screen when signal is broadcasted
  awesome.connect_signal("lock_screen::show", function()
    self:show()
    if self.widget ~= nil then self:get_input() end
  end)

  -- hide the lock screen when signal is broadcasted
  awesome.connect_signal("lock_screen::hide", function()
    self:hide()
  end)

  if self.widget ~= nil then
    self.textbox:connect_signal("widget::redraw_needed", function ()
      self.widget = self:create_widget()
      self.wrapper:setup(self.widget)
    end)
  end
end


-- Show lock screen
function LockScreen:show ()
  self.wrapper.visible = true
end


-- Hide lock screen
function LockScreen:hide ()
  self.wrapper.visible = false
end


-- Authenticate with user input
function LockScreen:authenticate (password)
  local pam = require("liblua_pam")

  return pam.auth_current_user(password)
end


-- Reset user input
function LockScreen:reset_input ()
end


-- Get input from user
function LockScreen:get_input ()
  awful.prompt.run {
    hooks = {
      -- Custom escape behaviour: Do not cancel input with Escape
      -- Instead, this will just clear any input received so far.
      {
        {}, "Escape",
        function()
          self:reset_input()
          self:get_input()
        end
      },

      -- Fix for Control+Delete crashing the keygrabber
      {
        { keys.ctrlkey }, "Delete",
        function ()
          self:reset_input()
          self:get_input()
        end
      },
    },

    keyreleased_callback  = function (_, __, input)
      -- self:update_mask(input)
    end,

    exe_callback = function(input)
      -- Check input
      if self:authenticate(input) then
        -- YAY
        self:hide()
      else
        -- NAY
        self:get_input()
      end
    end,

    textbox = self.textbox,
  }
end


-- ========================================
-- Initialization
-- ========================================

-- Add lib path to cpath
package.cpath = package.cpath .. ";" .. lib_path

-- First check library exists
if helpers.is_module_available("liblua_pam") then
  -- Add lockscreen to each screen
  awful.screen.connect_for_each_screen(function (s)
    s.lock_screen = LockScreen:new(s)
  end)

else
  -- If library not found show notification when activated
  local notify_lib_missing = function ()
    naughty.notify {
      icon  = beautiful.lock_screen_warning_icon,
      title = "Lock Screen",
      text  = "lua-pam library is missing. Please make sure it is installed."
    }
  end

  awesome.connect_signal("lock_screen::show", notify_lib_missing)
  awesome.connect_signal("lock_screen::hide", notify_lib_missing)
end
