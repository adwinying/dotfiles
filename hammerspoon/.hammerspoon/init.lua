--
--  _  _   _   __  __ __  __ ___ ___  ___ ___  ___   ___  _  _
-- | || | /_\ |  \/  |  \/  | __| _ \/ __| _ \/ _ \ / _ \| \| |
-- | __ |/ _ \| |\/| | |\/| | _||   /\__ \  _/ (_) | (_) | .` |
-- |_||_/_/ \_\_|  |_|_|  |_|___|_|_\|___/_|  \___/ \___/|_|\_|
--
--

-- =============================================================================
-- Initialization
-- =============================================================================

-- Load preferences
require("preferences")

-- Load libraries
require("libraries")

-- Load modules
require("modules")

-- Load keybindings
require("keybindings")

-- Show config load success message
hs.notify.show("Config Initialization Complete", "All ready to go!", "")
