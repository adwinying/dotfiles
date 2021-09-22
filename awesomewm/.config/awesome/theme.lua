--
-- theme.lua
-- Theme config
--

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

-- ========================================
-- Variables
-- ========================================

-- Theme color
local color = {
  lightblue = "#8fbcbb",
  darkblue  = "#2e3440",
  red       = "#bf616a",
  orange    = "#d08770",
  yellow    = "#ebcb8b",
  green     = "#a3be8c",
  white     = "#eceff4",
  black     = "#000000",
}

-- Font
theme.font = "Inconsolata Nerd Font 11"

-- Background
theme.bg_normal   = color.black
theme.bg_dark     = color.black
theme.bg_focus    = color.black
theme.bg_urgent   = color.black
theme.bg_minimize = color.black
theme.bg_systray  = color.black

-- Foreground
theme.fg_normal   = color.white
theme.fg_focus    = color.lightblue
theme.fg_urgent   = color.red
theme.fg_minimize = color.darkblue

-- Borders/Gaps
theme.useless_gap   = dpi(7)
theme.screen_margin = theme.useless_gap
theme.border_width  = dpi(0)
theme.border_normal = color.black
theme.border_focus  = color.lightblue
theme.border_marked = color.red

-- Topbar
theme.topbar_position = "top"
theme.topbar_height   = dpi(28)
theme.topbar_margin   = theme.useless_gap
theme.topbar_padding  = dpi(10)
theme.topbar_spacing  = dpi(10)

-- Taglist
theme.taglist_bg_empty    = theme.bg_normal
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_bg_urgent   = theme.bg_normal
theme.taglist_bg_focus    = theme.bg_normal

-- Tasklist
theme.tasklist_font      = theme.font
theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_bg_focus  = theme.bg_focus
theme.tasklist_bg_urgent = theme.bg_urgent
theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_fg_focus  = theme.fg_focus
theme.tasklist_fg_urgent = theme.fg_urgent

-- Notification
theme.notification_max_width = dpi(350)

-- System tray
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(5)

-- Titlebars
theme.titlebars_enabled = false


-- ========================================
-- Icons
-- ========================================

-- Layout icons
theme.layout_tile     = themes_path.."default/layouts/tilew.png"
theme.layout_floating = themes_path.."default/layouts/floatingw.png"
theme.layout_max      = themes_path.."default/layouts/maxw.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
