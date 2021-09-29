--
-- player.lua
-- player daemon
-- Dependencies:
--   playerctl
--
-- Signals:
-- daemon::player::status
--   player (string)
--   artist (string)
--   title (string)
--   status (string) [Playing | Paused | Stopped]
--

local helpers = require("helpers")

-- ========================================
-- Config
-- ========================================

-- script to monitor player events
-- Sleeps until player changes state
local monitor_script = [[ playerctl metadata --follow --format ]]
  .. '"<a>{{playerName}}</a><b>{{artist}}</b><c>{{title}}</c><d>{{status}}</d>"'


-- ========================================
-- Logic
-- ========================================

-- Main script
local emit_player_info = function (stdout)
  local player, artist, title, status = string.match(
    stdout,
    "^<a>(.*)</a><b>(.*)</b><c>(.*)</c><d>(.*)</d>$"
  )

  if player == nil
    and artist == nil
    and title == nil
    and status == nil then
      return
    end

  awesome.emit_signal("daemon::player::status", player, artist, title, status)
end


-- ========================================
-- Initialization
-- ========================================

-- -- Run once to initialize widgets
-- awful.spawn.easy_async_with_shell(check_script, function (stdout)
--   check_bluetooth(stdout)
-- end)

-- Start monitoring process
helpers.start_monitor(monitor_script, { stdout = emit_player_info })
