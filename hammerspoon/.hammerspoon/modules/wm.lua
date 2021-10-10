--
-- wm.lua
-- Window manager related config
--

local config = require("configs").wm

-- =============================================================================
-- Initialization
-- =============================================================================

-- disble window animations
hs.window.animationDuration = 0

-- initialize as global object so it's not garbage collected
Hhtwm = require("libraries.hhtwm")

-- set gap sizes
Hhtwm.margin = config.gap_size * 2

-- set screen margins
Hhtwm.screenMargin = {
  top    = config.menubar_offset + config.gap_size,
  bottom = config.gap_size,
  left   = config.gap_size,
  right  = config.gap_size,
}

-- set enabled layouts
Hhtwm.enabledLayouts = config.enabled_layouts

-- set default layout
Hhtwm.defaultLayout = config.default_layout

-- filters (window rules)
Hhtwm.filters = config.rules

-- start hhtwm
Hhtwm.start()
