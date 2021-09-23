--
-- theme.lua
-- Theme config
--

local dpi = require("beautiful").xresources.apply_dpi

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
theme.font      = "Inconsolata Nerd Font 11"
theme.text_font = "Inconsolata for Powerline 11"

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


-- ========================================
-- Common
-- ========================================

-- Titlebars
theme.titlebars_enabled = false

-- Borders/Gaps
theme.useless_gap   = dpi(7)
theme.screen_margin = theme.useless_gap
theme.border_width  = dpi(1)
theme.border_radius = dpi(5)
theme.border_focus  = color.lightblue
theme.border_marked = color.red
theme.border_normal = color.black

-- Tooltips
theme.tooltip_padding_x = dpi(10)
theme.tooltip_padding_y = dpi(5)

-- Notification
theme.notification_max_width    = dpi(350)
theme.notification_margin       = dpi(15)
theme.notification_border_width = dpi(0)
theme.notification_fg           = color.white
theme.notification_bg           = color.darkblue .. "55"
theme.notification_bg_critical  = color.red .. "55"
theme.notification_font         = theme.text_font


-- ========================================
-- Components
-- ========================================

-- Topbar
theme.topbar_position = "top"
theme.topbar_height   = dpi(28)
theme.topbar_margin   = theme.useless_gap
theme.topbar_padding  = dpi(12)
theme.topbar_spacing  = dpi(10)


-- ========================================
-- Widgets
-- ========================================

-- Taglist
theme.taglist_spacing = dpi(5)

theme.taglist_bg_empty    = theme.bg_normal
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_bg_urgent   = theme.bg_normal
theme.taglist_bg_focus    = theme.bg_normal

theme.taglist_fg_empty    = theme.fg_normal
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_fg_urgent   = theme.fg_urgent
theme.taglist_fg_focus    = theme.fg_focus

theme.taglist_icon_empty    = " "
theme.taglist_icon_occupied = " "
theme.taglist_icon_urgent   = " "
theme.taglist_icon_focus    = " "

-- Tasklist
theme.tasklist_font = theme.font

theme.tasklist_icon_visible = " "
theme.tasklist_icon_hidden  = " "

theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_bg_focus  = theme.bg_focus
theme.tasklist_bg_urgent = theme.bg_urgent
theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_fg_focus  = theme.fg_focus
theme.tasklist_fg_urgent = theme.fg_urgent

-- Calendar
theme.calendar_padding = dpi(20)
theme.calendar_spacing = dpi(10)

-- System tray
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(5)


-- Layout
local themes_path = require("gears.filesystem").get_themes_dir()

theme.layout_tile     = themes_path.."default/layouts/tilew.png"
theme.layout_floating = themes_path.."default/layouts/floatingw.png"
theme.layout_max      = themes_path.."default/layouts/maxw.png"


-- ========================================
-- Icons
-- ========================================

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
