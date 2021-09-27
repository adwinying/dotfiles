--
-- volume.lua
-- volume daemon
-- Dependencies:
--   pulseaudio
--
-- Signals:
-- daemon::volume::percentage
--   percentage (integer)
--
-- daemon::volume::muted
--

local awful = require("awful")
local helpers = require("helpers")

-- ========================================
-- Config
-- ========================================

-- script to monitor volume events
-- Sleeps until pactl detects an event (volume up/down/toggle mute)
local monitor_script = [[ pactl subscribe 2> /dev/null | grep --line-buffered "Event 'change' on sink #" ]]

-- script to get volume sinks
-- Gets volume info of the currently active sink
-- The currently active sink has a star `*` in front of its index
-- In the output of `pacmd list-sinks`, lines +7 and +11 after "* index:"
-- contain the volume level and muted state respectively
-- This is why we are using `awk` to print them.
local sinks_script = "pacmd list-sinks | awk '/\\* index: /{nr[NR+7];nr[NR+11]}; NR in nr'"

-- ========================================
-- Logic
-- ========================================

local volume_old = -1
local muted_old = -1

-- Main script
local check_volume = function ()
  awful.spawn.easy_async_with_shell(sinks_script, function(stdout)
    local volume = stdout:match("(%d+)%% /")
    local muted = stdout:match("muted:%s+yes")

    if volume == nil then return end

    local muted_int = muted and 1 or 0
    local volume_int = tonumber(volume)

    -- Only send signal if there was a change
    -- We need this since we use `pactl subscribe` to detect
    -- volume events. These are not only triggered when the
    -- user adjusts the volume through a keybind, but also
    -- through `pavucontrol` or even without user intervention,
    -- when a media file starts playing.
    if volume_int ~= volume_old
      or (muted_int ~= muted_old and muted_int == 0) then
      awesome.emit_signal("daemon::volume::percentage", volume_int)
      volume_old = volume_int
      muted_old = muted_int
    end

    if muted_int ~= muted_old and muted_int == 1 then
      awesome.emit_signal("daemon::volume::muted")
      muted_old = muted_int
    end
  end)
end


-- ========================================
-- Initialization
-- ========================================

-- Run once to initialize widgets
check_volume()

-- Start monitoring process
helpers.start_monitor(
  monitor_script,
  { stdout = check_volume }
)
