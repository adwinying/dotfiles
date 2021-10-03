--
-- key.lua
-- Keybindings and buttons
--

local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Define mod keys
local modkey   = "Mod4"
local altkey   = "Mod1"
local ctrlkey  = "Control"
local shiftkey = "Shift"

-- Define mouse button
local leftclick     = 1
local midclick      = 2
local rightclick    = 3
local scrolldown    = 4
local scrollup      = 5
local sidedownclick = 8
local sideupclick   = 9

local keys = {}

keys.modkey   = modkey
keys.altkey   = altkey
keys.ctrlkey  = ctrlkey
keys.shiftkey = shiftkey

keys.leftclick     = leftclick
keys.midclick      = midclick
keys.rightclick    = rightclick
keys.scrolldown    = scrolldown
keys.scrollup      = scrollup
keys.sidedownclick = sidedownclick
keys.sideupclick   = sideupclick


-- ========================================
-- Movement functions
-- ========================================

-- Move local client
local function move_client (c, direction)
  -- If client is floating, move to edge
  if c.floating
    or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
    local workarea = awful.screen.focused().workarea
    if direction == "up" then
      c:geometry({
        nil,
        y = workarea.y + beautiful.useless_gap * 2,
        nil,
        nil
      })
    elseif direction == "down" then
      c:geometry({
        nil,
        y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 2 - beautiful.border_width * 2,
        nil,
        nil
      })
    elseif direction == "left" then
      c:geometry({
        x = workarea.x + beautiful.useless_gap * 2,
        nil,
        nil,
        nil
      })
    elseif direction == "right" then
      c:geometry({
        x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 2 - beautiful.border_width * 2,
        nil,
        nil,
        nil
      })
    end
  -- If maxed layout then swap windows
  elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
    if direction == "up" or direction == "left" then
      awful.client.swap.byidx(-1, c)
    elseif direction == "down" or direction == "right" then
      awful.client.swap.byidx(1, c)
    end
  -- Otherwise swap the client in the tiled layout
  else
    awful.client.swap.bydirection(direction, c, nil)
  end
end

-- Resize local client
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

local function resize_client (c, direction)
  if awful.layout.get(mouse.screen) == awful.layout.suit.floating
    or (c and c.floating) then
    if direction == "up" then
      c:relative_move(0, 0, 0, -floating_resize_amount)
    elseif direction == "down" then
      c:relative_move(0, 0, 0, floating_resize_amount)
    elseif direction == "left" then
      c:relative_move(0, 0, -floating_resize_amount, 0)
    elseif direction == "right" then
      c:relative_move(0, 0, floating_resize_amount, 0)
    end
  else
    if direction == "up" then
      awful.client.incwfact(-tiling_resize_factor)
    elseif direction == "down" then
      awful.client.incwfact(tiling_resize_factor)
    elseif direction == "left" then
      awful.tag.incmwfact(-tiling_resize_factor)
    elseif direction == "right" then
      awful.tag.incmwfact(tiling_resize_factor)
    end
  end
end

-- Raise focus client
local function raise_client ()
  if client.focus then
    client.focus:raise()
  end
end


-- ========================================
-- Mouse bindings
-- ========================================

-- Mouse buttons on desktop
keys.desktopbuttons = gears.table.join(
  awful.button(
    {}, leftclick,
    function () naughty.destroy_all_notifications() end
  )
)

-- Mouse buttons on client
keys.clientbuttons = gears.table.join(
  awful.button(
    {}, leftclick,
    function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
    end
  ),
  awful.button(
    { modkey }, leftclick,
    function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.move(c)
    end
  ),
  awful.button(
    { modkey }, rightclick,
    function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.resize(c)
    end
  )
)

-- ========================================
-- Client Keybindings
-- ========================================

keys.clientkeys = gears.table.join(
  awful.key(
    { modkey, shiftkey }, "j",
    function (c) move_client(c, "down") end,
    { description = "move down", group = "client" }
  ),

  awful.key(
    { modkey, shiftkey }, "k",
    function (c) move_client(c, "up") end,
    { description = "move up", group = "client" }
  ),

  awful.key(
    { modkey, shiftkey }, "h",
    function (c) move_client(c, "left") end,
    { description = "move left", group = "client" }
  ),

  awful.key(
    { modkey, shiftkey }, "l",
    function (c) move_client(c, "right") end,
    { description = "move right", group = "client" }
  ),

  awful.key(
    { modkey }, "f",
    function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "toggle fullscreen", group = "client" }
  ),

  awful.key(
    { modkey }, "t",
    function (c) c.ontop = not c.ontop end,
    { description = "toggle keep on top", group = "client" }
  ),

  awful.key(
    { modkey, shiftkey }, "c",
    function (c) c:kill() end,
    { description = "close", group = "client" }
  ),

  awful.key(
    { modkey }, "q",
    function (c) c:kill() end,
    { description = "close", group = "client" }
  ),

  awful.key(
    { modkey }, "n",
    function (c) c.minimized = true end,
    { description = "minimize", group = "client" }
  ),

  awful.key(
    { modkey }, "m",
    function (c)
      c.maximized = not c.maximized
      c:raise()
    end,
    { description = "(un)maximize", group = "client" }
  ),

  awful.key(
    { modkey, ctrlkey }, "space",
    awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }
  )
)

-- ========================================
-- Global Keybindings
-- ========================================

keys.globalkeys = gears.table.join(
  -- ========================================
  -- Awesome General
  -- ========================================
  awful.key(
    { modkey, shiftkey }, "/",
    hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }
  ),

  awful.key(
    { modkey, shiftkey }, "r",
    awesome.restart,
    { description = "reload awesome", group = "awesome" }
  ),

  awful.key(
    { modkey }, "Escape",
    function () awesome.emit_signal("exit_screen::show") end,
    { description = "show exit screen", group = "awesome" }
  ),

  awful.key(
    {}, "XF86PowerOff",
    function () awesome.emit_signal("exit_screen::show") end,
    { description = "show exit screen", group = "awesome" }
  ),

  awful.key(
    { modkey }, "Tab",
    function () awful.screen.focused().window_switcher:show() end,
    {description = "activate window switcher", group = "awesome"}
  ),

  awful.key(
    { modkey }, "=",
    function () awesome.emit_signal("widget::systray::toggle") end,
    {description = "toggle systray", group = "awesome"}
  ),


  -- ========================================
  -- Screen focus
  -- ========================================
  awful.key(
    { modkey, ctrlkey }, "s",
    function () awful.screen.focus_relative(1) end,
    { description = "focus next screen", group = "screen" }
  ),

  awful.key(
    { modkey, ctrlkey }, "S",
    function () awful.screen.focus_relative(-1) end,
    { description = "focus previous screen", group = "screen" }
  ),


  -- ========================================
  -- Client focus
  -- ========================================
  awful.key(
    { modkey }, "j",
    function ()
      awful.client.focus.bydirection("down")
      raise_client()
    end,
    { description = "focus down", group = "client" }
  ),

  awful.key(
    { modkey }, "k",
    function ()
      awful.client.focus.bydirection("up")
      raise_client()
    end,
    { description = "focus up", group = "client" }
  ),

  awful.key(
    { modkey }, "h",
    function ()
      awful.client.focus.bydirection("left")
      raise_client()
    end,
    { description = "focus left", group = "client" }
  ),

  awful.key(
    { modkey }, "l",
    function ()
      awful.client.focus.bydirection("right")
      raise_client()
    end,
    { description = "focus right", group = "client" }
  ),


  -- ========================================
  -- Client resize
  -- ========================================
  awful.key(
    { modkey, ctrlkey }, "j",
    function () resize_client(client.focus, "down") end,
    { description = "resize down", group = "client" }
  ),

  awful.key(
    { modkey, ctrlkey }, "k",
    function () resize_client(client.focus, "up") end,
    { description = "resize up", group = "client" }
  ),

  awful.key(
    { modkey, ctrlkey }, "h",
    function () resize_client(client.focus, "left") end,
    { description = "resize left", group = "client" }
  ),

  awful.key(
    { modkey, ctrlkey }, "l",
    function () resize_client(client.focus, "right") end,
    { description = "resize right", group = "client" }
  ),

  awful.key(
    { modkey, shiftkey }, "n",
    function ()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal("request::activate", "key.unminimize", { raise = true })
      end
    end,
    { description = "restore minimized", group = "client" }
  ),


  -- ========================================
  -- Gap control
  -- ========================================
  awful.key(
    { modkey, shiftkey }, "minus",
    function () awful.tag.incgap(5, nil) end,
    { description = "increment gaps size for current tag", group = "tag" }
  ),

  awful.key(
    { modkey }, "minus",
    function () awful.tag.incgap(-5, nil) end,
    { description = "decrement gaps size for current tag", group = "tag" }
  ),


  -- ========================================
  -- Layout selection
  -- ========================================
  awful.key(
    { modkey }, "space",
    function () awful.layout.inc(1) end,
    { description = "select next", group = "layout" }
  ),

  awful.key(
    { modkey, shiftkey }, "space",
    function () awful.layout.inc(-1) end,
    { description = "select previous", group = "layout" }
  ),

  awful.key(
    { modkey }, "w",
    function () awful.layout.set(awful.layout.suit.max) end,
    { description = "select max layout", group = "layout" }
  ),

  awful.key(
    { modkey }, "s",
    function () awful.layout.set(awful.layout.suit.tile) end,
    { description = "select tile layout", group = "layout" }
  ),

  awful.key(
    { modkey, shiftkey }, "s",
    function () awful.layout.set(awful.layout.suit.floating) end,
    { description = "select floating layout", group = "layout" }
  ),


  -- ========================================
  -- Applications
  -- ========================================
  awful.key(
    { modkey }, "`",
    function () awesome.emit_signal("floating_terminal::toggle") end,
    { description = "toggle floating terminal", group = "hotkeys" }
  ),

  awful.key(
    { modkey }, "Return",
    function () awful.spawn(Apps.terminal) end,
    { description = "terminal", group = "hotkeys" }
  ),

  awful.key(
    { modkey }, "e",
    function ()
      awful.spawn.with_shell([[ notify-send "Current Weather" "$(curl "wttr.in?T0")" ]])
    end,
    { description = "get current weather", group = "hotkeys" }
  ),

  awful.key(
    { modkey }, "d",
    function () awful.spawn(Apps.launcher) end,
    { description = "application launcher", group = "hotkeys" }
  ),

  awful.key(
    { modkey }, "b",
    function () awful.spawn(Apps.web_browser) end,
    { description = "web browser", group = "hotkeys" }
  ),


  -- ========================================
  -- Screenshot
  -- ========================================
  awful.key(
    {}, "Print",
    function ()
      awful.spawn.with_shell(Apps.screenshot .. "  | xclip -sel clip -t image/png" )
      naughty.notify {
        icon = beautiful.icons_path .. "screenshot.svg",
        title = "Screenshot",
        text = "Screenshot of screen stored in clipboard.",
      }
    end,
    { description = "take a screenshot", group = "hotkeys" }
  ),

  awful.key(
    { modkey }, "Print",
    function ()
      os.execute(Apps.screenshot .. " -s  | xclip -sel clip -t image/png" )
      naughty.notify {
        icon = beautiful.icons_path .. "screenshot.svg",
        title = "Screenshot",
        text = "Screenshot of selected area stored in clipboard.",
      }
    end,
    { description = "take a screenshot selection", group = "hotkeys" }
  ),

  awful.key(
    { modkey, shiftkey }, "Print",
    function ()
      awful.spawn.with_shell(Apps.screenshot .. " -d 5 | xclip -sel clip -t image/png" )

      gears.timer {
        timeout = 5,
        autostart = true,
        single_shot = true,
        callback = function ()
          naughty.notify {
            icon = beautiful.icons_path .. "screenshot.svg",
            title = "Screenshot",
            text = "Screenshot of screen stored in clipboard.",
          }
        end
      }
    end,
    { description = "take a screenshot after 5 secs", group = "hotkeys" }
  ),


  -- ========================================
  -- Language
  -- ========================================
  awful.key(
    { ctrlkey }, "space",
    helpers.switch_language,
    { description = "switch language", group = "hotkeys" }
  ),

  awful.key(
    {}, "Hangul_Hanja",
    function () helpers.set_language("en") end,
    { description = "set language to en", group = "hotkeys" }
  ),

  awful.key(
    {}, "Hangul",
    function () helpers.set_language("ja") end,
    { description = "set language to ja", group = "hotkeys" }
  ),


  -- ========================================
  -- Function keys
  -- ========================================
  -- Brightness
  awful.key(
    {}, "XF86MonBrightnessUp",
    function () helpers.change_brightness(5) end,
    { description = "brightness up", group = "hotkeys" }
  ),
  awful.key(
    {}, "XF86MonBrightnessDown",
    function () helpers.change_brightness(-5) end,
    { description = "brightness down", group = "hotkeys" }
  ),

  -- Volume/Playback
  awful.key(
    {}, "XF86AudioRaiseVolume",
    function () helpers.change_volume(5) end,
    { description = "volume up", group = "hotkeys" }
  ),
  awful.key(
    {}, "XF86AudioLowerVolume",
    function () helpers.change_volume(-5) end,
    { description = "volume down", group = "hotkeys" }
  ),
  awful.key(
    {}, "XF86AudioMute",
    helpers.toggle_volume_mute,
    { description = "toggle mute", group = "hotkeys" }
  ),
  awful.key(
    {}, "XF86AudioNext",
    helpers.media_next,
    { description = "next track", group = "hotkeys" }
  ),
  awful.key(
    {}, "XF86AudioPrev",
    helpers.media_prev,
    { description = "previous track", group = "hotkeys" }
  ),
  awful.key(
    {}, "XF86AudioPlay",
    helpers.media_play_pause,
    { description = "play/pause music", group = "hotkeys" }
  )
)

-- Bind all key numbers to tags
for i = 1, #Tags do
  local tag_name = string.format("#%s: %s", i, Tags[i].name)

  keys.globalkeys = gears.table.join(keys.globalkeys,
    -- Switch to tags
    awful.key(
      { modkey }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]

        if tag then tag:view_only() end
      end,
      { description = "view tag " .. tag_name, group = "tag" }
    ),

    -- Toggle tag display
    awful.key(
      { modkey, ctrlkey }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "toggle tag " .. tag_name, group = "tag" }
    ),

    -- Move client to tag.
    awful.key(
      { modkey, shiftkey }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag " .. tag_name, group = "tag" }
    ),

    -- Toggle tag on focused client.
    awful.key(
    { modkey,ctrlkey , shiftkey }, "#" .. i + 9,
    function ()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end,
    { description = "toggle focused client on tag " .. tag_name, group = "tag" }
    )
  )
end

return keys
