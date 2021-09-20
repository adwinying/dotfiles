--
-- theme.lua
-- Theme config
--

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

-- ========================================
-- Variables
-- ========================================

-- Font
theme.font          = "monospace 8"

-- Background
theme.bg_normal     = "#1f2430"
theme.bg_dark       = "#000000"
theme.bg_focus      = "#151821"
theme.bg_urgent     = "#ef8274"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

-- Foreground
theme.fg_normal     = "#ffffff"
theme.fg_focus      = "#e4e4e4"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

-- Borders/Gaps
theme.useless_gap   = dpi(7)
theme.border_width  = dpi(0)
theme.border_normal = theme.bg_normal
theme.border_focus  = "#ff8a65"
theme.border_marked = theme.fg_urgent

-- Taglist
theme.taglist_bg_empty    = theme.bg_normal
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_bg_urgent   = "#e91e6399"
theme.taglist_bg_focus    = theme.bg_focus

-- Tasklist
theme.tasklist_font      = theme.font
theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_bg_focus  = theme.bg_focus
theme.tasklist_bg_urgent = theme.bg_urgent
theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_fg_focus  = theme.fg_focus
theme.tasklist_fg_urgent = theme.fg_urgent

-- Panel
theme.top_panel_height = dpi(26)

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
