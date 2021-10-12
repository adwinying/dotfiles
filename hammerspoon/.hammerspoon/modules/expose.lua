--
-- expose.lua
-- keyboard-driven expose config
--

hs.expose.ui.textColor = { 0.9, 0.9, 0.9 }

hs.expose.ui.fontName = "HackGen Console"
hs.expose.ui.textSize = 30

hs.expose.ui.highlightColor  = { 0.56, 0.74, 0.73, 0.8 }
hs.expose.ui.backgroundColor = { 0, 0, 0, 0.8 }

-- "close mode" engaged while pressed (or 'cmd','ctrl','alt')
hs.expose.ui.closeModeModifier        = "cmd"
hs.expose.ui.closeModeBackgroundColor = { 0.75, 0.38, 0.42, 0.8 }

-- "minimize mode" engaged while pressed
hs.expose.ui.minimizeModeModifier        = "shift"
hs.expose.ui.minimizeModeBackgroundColor = { 0.92, 0.80, 0.55, 0.8 }

-- only show windows of the active application
hs.expose.ui.onlyActiveApplication = false
-- include minimized and hidden windows
hs.expose.ui.includeNonVisible = true
-- contains hints for non-visible windows
hs.expose.ui.nonVisibleStripBackgroundColor = { 0, 0, 0, 0.8 }
-- set it to your Dock position ('bottom', 'left' or 'right')
hs.expose.ui.nonVisibleStripPosition = "bottom"
-- 0..0.5, width of the strip relative to the screen
hs.expose.ui.nonVisibleStripWidth = 0.1

-- include windows in other Mission Control Spaces
hs.expose.ui.includeOtherSpaces              = false
hs.expose.ui.otherSpacesStripBackgroundColor = { 0.1, 0.1, 0.1, 1 }
hs.expose.ui.otherSpacesStripPosition        = "top"
hs.expose.ui.otherSpacesStripWidth           = 0.2

-- show window titles
hs.expose.ui.showTitles = true
-- show window thumbnails
hs.expose.ui.showThumbnails = true
-- 0..1, opacity for thumbnails
hs.expose.ui.thumbnailAlpha = 0
-- 0..1, opacity for thumbnails of candidate windows
hs.expose.ui.highlightThumbnailAlpha = 1
-- thumbnail frame thickness for candidate windows
hs.expose.ui.highlightThumbnailStrokeWidth = 8
-- if necessary, hints longer than this will be disambiguated with digits
hs.expose.ui.maxHintLetters = 2
-- lower is faster, but higher chance of overlapping thumbnails
hs.expose.ui.fitWindowsMaxIterations = 30
-- improves responsivenss, but can affect the rest of the config
hs.expose.ui.fitWindowsInBackground = false
