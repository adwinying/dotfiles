--
-- player.lua
-- player status notification
--

local naughty = require("naughty")
local beautiful = require("beautiful")

-- ========================================
-- Config
-- ========================================

local icons_path = beautiful.icons_path .. "player/"


-- ========================================
-- Logic
-- ========================================

-- Determine player icon
local get_player_icon = function (status)
  local icon_map = {
    Playing = icons_path .. "player_playing.svg",
    Paused  = icons_path .. "player_paused.svg",
    Stopped = icons_path .. "player_stopped.svg",
  }

  return icon_map[status]
end


-- Notify player status
local notify_player_status = function (player, artist, title, status)
  return naughty.notify {
    icon = get_player_icon(status),
    title = string.format("%s - %s", player, status),
    text = string.format("%s\n%s", artist, title),
  }
end


-- ========================================
-- Initialization
-- ========================================

local notification

awesome.connect_signal("daemon::player::status", function (...)
  -- Remove existing notification
  if notification then naughty.destroy(notification) end

  notification = notify_player_status(...)
end)
