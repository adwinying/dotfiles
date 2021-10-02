--
-- rules.lua
-- Client rules
--

local awful = require("awful")
local beautiful = require("beautiful")
local keys = require("keys")

local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

local rules = {
  -- All clients will match this rule.
  {
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keys.clientkeys,
      buttons = keys.clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",
        "Sxiv",
        "Tor Browser",
        "Wpa_gui",
        "veromix",
        "xtightvncviewer",
        "plasmashell",
        "Plasma",
      },
      name = {
        "Event Tester",  -- xev.
        "Steam Guard - Computer Authorization Required",
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "ConfigManager",  -- Thunderbird's about:config.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        "GtkFileChooserDialog",
      },
      type = {
        "dialog",
      },
    },
    properties = {
      placement = awful.placement.centered,
      floating = true,
    },
  },

  -- Fullscreen clients
  -- {
  --   rule_any = {
  --     class = {
  --       "Terraria.bin.x86",
  --     },
  --   },
  --   properties = { fullscreen = true },
  -- },

  -- -- Switch to tag
  -- -- These clients make you switch to their tag when they appear
  -- {
  --   rule_any = {
  --     class = {
  --       "Brave",
  --     },
  --   },
  --   properties = { switchtotag = true },
  -- },

  -- File chooser dialog
  {
    rule_any = {
      role = {
        "GtkFileChooserDialog",
      },
      properties = {
        floating = true,
        width = screen_width * 0.55,
        height = screen_height * 0.65,
      },
    },
  },

  -- Pavucontrol & Bluetooth Devices
  {
    rule_any = {
      class = {
        "Pavucontrol",
      },
      name = {
        "Bluetooth Devices",
      },
      properties = {
        floating = true,
        width = screen_width * 0.55,
        height = screen_height * 0.45,
      },
    },
  },

  -- Set Brave to always map on the tag named "web" on screen 1.
  {
    rule = {
      class = "Brave",
    },
    properties = {
      screen = 1,
      tag = "web",
    },
  },
}

return rules
