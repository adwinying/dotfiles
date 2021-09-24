--
-- battery.lua
-- battery daemon
--
-- Dependencies:
--   acpi
--
-- Signals:
-- daemon::battery::status
--   batteries (table) {
--      status (string)
--      percentage (integer)
--      capacity (integer)
--   }
--   battery (table) {
--      status (string)
--      percentage (integer)
--      capacity (integer)
--   }
--   summary (string)
--

local awful = require("awful")
local gears = require("gears")

-- ========================================
-- Config
-- ========================================

-- update interval
local update_interval = 30
-- script to check whether system has battery
local battery_check_script = "find /sys/class/power_supply/BAT?"
-- script to get battery status
local battery_status_script = "acpi -i"


-- ========================================
-- Logic
-- ========================================

-- parse stdout from command
local parse_stdout = function(stdout)
  local battery_info = {}
  local capacities = {}

  for s in stdout:gmatch("[^\r\n]+") do
    local status, charge_str, time = string.match(s, ".+: (%a+), (%d?%d?%d)%%,?.*")
    if status ~= nil then
      table.insert(battery_info, {status = status, percentage = tonumber(charge_str)})
    else
      local cap_str = string.match(s, ".+:.+last full capacity (%d+)")
      table.insert(capacities, tonumber(cap_str))
    end
  end

  local result = {}
  for i = 1, #battery_info, 1 do
    result[i] = {
      status = battery_info[i].status,
      percentage = battery_info[i].percentage,
      capacity = capacities[i],
    }
  end

  return result
end


-- get overall battery status
local get_overall_battery_status = function (batt_stats)
  local charge = 0
  local capacity = 0
  local status = "Unknown"
  local status_count = {}
  local status_priority = {
    "Charging",
    "Full",
    "Discharging",
    "Unknown",
  }

  for _, stat in ipairs(batt_stats) do
    status_count[stat.status] = (status_count[stat.status] or 0) + 1
    charge = charge + stat.percentage * stat.capacity
    capacity = capacity + stat.capacity
  end

  for _, stat in ipairs(status_priority) do
    if status_count[stat] ~= nil then
      status = stat
      break
    end
  end

  return {
    status = status,
    percentage = charge / capacity,
    capacity = capacity,
  }
end


-- Main script
local check_battery = function ()
  awful.spawn.easy_async_with_shell(battery_status_script, function(stdout)
    local stats = parse_stdout(stdout)
    local overall_stats = get_overall_battery_status(stats)

    awesome.emit_signal("daemon::battery::status", stats, overall_stats, stdout)

    collectgarbage("collect")
  end)
end


-- ========================================
-- Initialization
-- ========================================

-- First get battery file path
awful.spawn.easy_async_with_shell(battery_check_script, function (_, __, ___, exit_code)
  -- If battery file not found do nothing
  if exit_code ~= 0 then return end

  -- Periodically get battery info
  gears.timer {
    timeout = update_interval,
    autostart = true,
    call_now = true,
    callback = check_battery,
  }
end)
