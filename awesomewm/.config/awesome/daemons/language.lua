--
-- language.lua
-- language daemon
-- Dependencies:
--   ibus
--
-- Signals:
-- daemon::language
--   language (string)
--

local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")

-- ========================================
-- Config
-- ========================================

-- update interval
local update_interval = 30

-- script to get current ibus engine
local current_engine_script = "ibus engine"


-- ========================================
-- Logic
-- ========================================

-- Main script
local emit_current_engine = function ()
  awful.spawn.easy_async_with_shell(current_engine_script, function (stdout)
    local language = helpers.get_language(stdout:gsub("%s+", ""))

    awesome.emit_signal("daemon::language", language)
  end)
end


-- ========================================
-- Initialization
-- ========================================

-- Check engine periodically
gears.timer {
  timeout = update_interval,
  autostart = true,
  call_now = true,
  callback = emit_current_engine,
}
