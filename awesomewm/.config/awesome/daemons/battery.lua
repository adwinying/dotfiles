--
-- battery.lua
-- battery daemon
--
-- Dependencies:
--   acpi
--
-- Signals:
-- daemon::battery
--   batteries (table) {
--      status (string)
--      percentage (integer)
--      capacity (integer)
--   }
--   summary (string)
--

local awful = require("awful")

-- ========================================
-- Config
-- ========================================

-- update interval
local update_interval = 30
-- script to check whether system has battery
local battery_check_script = "find /sys/class/power_supply/BAT?"
-- script to get battery status
local battery_status_script = "acpi -i"
-- Subscribe to power supply status changes with acpi_listen
local charger_script = "acpi_listen | grep --line-buffered ac_adapter"


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


-- ========================================
-- Initialization
-- ========================================

-- First get battery file path
awful.spawn.easy_async_with_shell(battery_check_script, function (batteries, _, __, exit_code)
  -- If battery file not found do nothing
  if exit_code ~= 0 then return end

  -- Periodically get battery info
  awful.widget.watch(battery_status_script, update_interval, function(_, stdout)
    awesome.emit_signal("daemon::battery", parse_stdout(stdout), stdout)
  end)
end)
