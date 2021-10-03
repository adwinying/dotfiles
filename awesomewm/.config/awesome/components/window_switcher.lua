--
-- window_switcher.lua
-- window switcher component
--

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("helpers")
local keys = require("keys")

-- ========================================
-- Config
-- ========================================

-- switcher Commands
local switcher_commands = {
  hide = function()
    awesome.emit_signal("window_switcher::hide")
  end,

  search_client = function()
    awesome.emit_signal("window_switcher::hide")
    awful.spawn.with_shell("rofi -show window")
  end,
}

-- Client Commands
local client_commands = {
  minimize = function()
    if client.focus then client.focus.minimized = true end
  end,

  unminimize = function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then client.focus = c end
  end,

  close = function()
    if client.focus then client.focus:kill() end
  end,

  focus_prev = function ()
    awful.client.focus.byidx(-1)
  end,

  focus_next = function ()
    awful.client.focus.byidx(1)
  end,
}

-- Set up keybindings
local keybindings = {
  -- Search
  [' '] = switcher_commands.search_client,

  -- Hide switcher
  ['Escape'] = switcher_commands.hide,
  ['Tab']    = client_commands.focus_next,

  -- (Un)Minimize
  ['n'] = client_commands.minimize,
  ['N'] = client_commands.unminimize,
  ['u'] = client_commands.unminimize, -- `u` for up

  -- Close
  ['d'] = client_commands.close,
  ['q'] = client_commands.close,

  -- Move with vim keys
  ['j'] = client_commands.focus_next,
  ['k'] = client_commands.focus_prev,

  -- Move with arrow keys
  ['Down'] = client_commands.focus_next,
  ['Up']   = client_commands.focus_prev,
}


-- ========================================
-- Logic
-- ========================================

-- Define a new class
local Switcher = {}
Switcher.__index = Switcher


-- Class constructor
function Switcher:new (screen)
  -- create new class instance
  local switcher = {}
  setmetatable(switcher, Switcher)

  -- screen instance
  switcher.screen = screen
  -- screen grabber instance
  switcher.screen_grabber = nil
  -- first client when the window switcher was activated
  switcher.first_client = nil
  -- minimized clients when the window switcher was activated
  switcher.minimized_clients = {}
  -- lasat client before the window switcher was deactivated
  switcher.last_client = nil

  -- create widget components
  switcher.tasklist = switcher:create_tasklist()
  switcher.popup = switcher:create_popup()
  switcher:init_signals()

  return switcher
end


-- Create Tasklist
function Switcher:create_tasklist ()
  return awful.widget.tasklist {
    screen  = self.screen,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = self:get_mousebindings(),
    layout  = {
      layout  = wibox.layout.fixed.vertical,
      spacing = beautiful.window_switcher_spacing_y,
    },
    widget_template = {
        layout  = wibox.layout.fixed.horizontal,
        spacing = beautiful.window_switcher_spacing_x,
        {
          id = "icon_role",
          widget = wibox.widget.imagebox,
          resize = true,
          forced_height = beautiful.window_switcher_icon_height,
          forced_width = beautiful.window_switcher_icon_width,
        },
        {
          id            = "text_role",
          widget        = wibox.widget.textbox,
          forced_height = beautiful.window_switcher_icon_height,
          ellipsize     = "end",
          align         = "left",
          valign        = "center",
        },
    },
  }
end


-- Create popup
function Switcher:create_popup ()
  return awful.popup {
    visible   = false,
    ontop     = true,
    screen    = self.screen,
    placement = awful.placement.centered,
    bg        = beautiful.window_switcher_bg,
    shape     = helpers.rrect,
    widget    = {
      widget       = wibox.container.margin,
      top          = beautiful.window_switcher_margin_y,
      bottom       = beautiful.window_switcher_margin_y,
      left         = beautiful.window_switcher_margin_x,
      right        = beautiful.window_switcher_margin_x,
      forced_width = beautiful.window_switcher_width,
      self.tasklist,
    },
  }
end


-- Init signals
function Switcher:init_signals ()
  -- Hide popup when signal emitted
  awesome.connect_signal("window_switcher::hide", function () self:hide() end)
end

-- Get mousebindings
-- Use 'Any' modifier so that the same buttons can be used in the floating
-- tasklist displayed by the window switcher while the superkey is pressed
function Switcher:get_mousebindings ()
  return gears.table.join(
    -- Left click (un)minimizes client
    awful.button(
      { 'Any' }, keys.leftclick, nil,
      function (c)
        if c == client.focus then
          c.minimized = true
        else
          -- Without this, the following
          -- :isvisible() makes no sense
          c.minimized = false
          if not c:isvisible() and c.first_tag then
              c.first_tag:view_only()
          end
          -- This will also un-minimize
          -- the client, if needed
          client.focus = c
        end
      end
    ),

    -- Middle click closes the client (on release)
    awful.button(
      { 'Any' }, keys.midclick, nil,
      function (c) c:kill() end
    ),

    -- Right click minimizes the client
    awful.button(
      { 'Any' }, keys.rightclick, nil,
      function (c) c.minimized = true end
    ),

    -- Scroll to switch focused client
    awful.button(
      { 'Any' }, keys.scrolldown,
      client_commands.focus_next
    ),
    awful.button(
      { 'Any' }, keys.scrollup,
      client_commands.focus_prev
    ),

    -- Side button up - toggle floating
    awful.button(
      { 'Any' }, keys.sideupclick,
      function(c) c.floating = not c.floating end
    ),

    -- Side button down - toggle ontop
    awful.button(
      { 'Any' }, keys.sidedownclick,
      function(c) c.ontop = not c.ontop end
    )
  )
end


-- Activate keybindings
function Switcher:activate_keybindings ()
  self.screen_grabber = awful.keygrabber.run(function(_, key, event)
    -- Hide if the modifier was released
    if event == "release" then
      -- We try to match Super or Alt or Control
      -- since we do not know which keybind is used to activate the switcher
      -- (the keybind is set by the user in keys.lua)
      if key:match("Super") or key:match("Alt") or key:match("Control") then
        self:hide()
      end
      -- Do nothing
      return
    end

    -- Run function attached to key, if it exists
    local cmd = keybindings[key]

    if cmd ~= nil then cmd() end
  end)
end


-- Deactivate keybindings
function Switcher:deactivate_keybindings ()
  awful.keygrabber.stop(self.screen_grabber)
end


-- Show window switcher
function Switcher:show ()
  -- If no available clients then do nothing
  if #self.screen.selected_tag:clients() == 0 then return end

  -- Update first client
  self.first_client = client.focus

  -- Stop recording focus history
  awful.client.focus.history.disable_tracking()

  -- Go to previously focused client (in the tag)
  awful.client.focus.history.previous()

  -- Track minimized clients
  -- Unminimize them
  -- Lower them so that they are always below originally unminimized windows
  local clients = self.screen.selected_tag:clients()
  for _, c in pairs(clients) do
    if c.minimized then
      table.insert(self.minimized_clients, c)
      c.minimized = false
      c:lower()
    end
  end

  -- Activate keybindings
  self:activate_keybindings()

  -- Finally make the popup visible after a small delay,
  -- to allow the popup size to update
  gears.timer.delayed_call(function() self.popup.visible = true end)
end


-- Hide window switcher
function Switcher:hide ()
  if client.focus then
    -- Add currently focused client to history
    self.last_client = client.focus
    awful.client.focus.history.add(self.last_client)

    -- Raise client that was focused originally and last focused client
    if self.first_client then self.first_client:raise() end
    if self.last_client then self.last_client:raise() end
  end

  -- Minimize originally minimized clients
  for _, c in pairs(self.minimized_clients) do
    if c and c.valid and not (client.focus and client.focus == c) then
      c.minimized = true
    end
  end

  -- Reset minimized clients
  self.minimized_clients = {}

  -- Resume recording focus history
  awful.client.focus.history.enable_tracking()

  -- Deactivate keybindings
  self:deactivate_keybindings()

  -- Hide popup
  self.popup.visible = false
end


-- ========================================
-- Initialization
-- ========================================

awful.screen.connect_for_each_screen(function (s)
  s.window_switcher = Switcher:new(s)
end)
