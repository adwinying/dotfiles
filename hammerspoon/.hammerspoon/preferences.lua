--
-- preferences.lua
-- Hammerspoon preferences
--

-- Check accessibility settings granted to hammerspoon
hs.accessibilityState(true)

-- Launch on login
hs.autoLaunch(true)

-- Check for updates
hs.automaticallyCheckForUpdates(true)

-- Always show console on top
hs.consoleOnTop(true)

-- Show menu icon
hs.menuIcon(true)

-- Hide dock icon
hs.dockIcon(false)

-- Enable dark mode
hs.preferencesDarkMode(true)

-- Don't report crashes
hs.uploadCrashData(false)
