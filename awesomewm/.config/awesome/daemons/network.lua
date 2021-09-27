--
-- network.lua
-- network daemon
-- Dependencies:
--   iproute2
--   iw
--
-- Signals:
-- daemon::network::status::wired
--   interface (string)
--   healthy (boolean)
--
-- daemon::network::status::wireless
--   interface (string)
--   healthy (boolean)
--   essid (string)
--   bitrate (string)
--   strength (integer)
--
-- daemon::network::connected::wired
--   interface (string)
--
-- daemon::network::connected::wireless
--   interface (string)
--   essid (string)
--
-- daemon::network::disconnected::wired
--   interface (string)
--
-- daemon::network::disconnected::wireless
--   interface (string)
--

local awful = require("awful")
local gears = require("gears")

-- ========================================
-- Config
-- ========================================

-- update interval
local update_interval = 30

-- script to determine network mode
local network_mode_script = [=[
wireless="]=] .. tostring(Network_Interfaces.wlan) .. [=["
wired="]=] .. tostring(Network_Interfaces.lan) .. [=["
net="/sys/class/net/"

wired_state="down"
wireless_state="down"
network_mode=""

# Check network state based on interface's operstate value
function check_network_state() {
  # Check what interface is up
  if [[ "${wireless_state}" == "up" ]];
  then
    network_mode='wireless'
  elif [[ "${wired_state}" == "up" ]];
  then
    network_mode='wired'
  else
    network_mode='No internet connection'
  fi
}

# Check if network directory exist
function check_network_directory() {
  if [[ -n "${wireless}" && -d "${net}${wireless}" ]];
  then
    wireless_state="$(cat "${net}${wireless}/operstate")"
  fi
  if [[ -n "${wired}" && -d "${net}${wired}" ]]; then
    wired_state="$(cat "${net}${wired}/operstate")"
  fi
  check_network_state
}

# Start script
function print_network_mode() {
  # Call to check network dir
  check_network_directory
  # Print network mode
  printf "${network_mode}"
}

print_network_mode
]=]

-- script to check whether can connect to internet
local healthcheck_script = [=[
status_ping=0

packets="$(ping -q -w2 -c2 example.com | grep -o "100% packet loss")"
if [ ! -z "${packets}" ];
then
  status_ping=0
else
  status_ping=1
fi

if [ $status_ping -eq 0 ];
then
  echo 'Connected but no internet'
fi
]=]

-- script to check wireless status
local wireless_data_script = "iw dev " .. Network_Interfaces.wlan .. " link"

-- script to check wireless strength
local wireless_strength_script = [[awk 'NR==3 {printf "%3.0f" ,($3/70)*100}' /proc/net/wireless]]


-- ========================================
-- Logic
-- ========================================

local network_mode = nil


-- Emit wireless connection status
local emit_wireless_status = function()
  awful.spawn.easy_async_with_shell(wireless_data_script, function(data_stdout)
    awful.spawn.easy_async_with_shell(wireless_strength_script, function(strength_stdout)
      awful.spawn.easy_async_with_shell(healthcheck_script, function(health_stdout)
        local interface = Network_Interfaces.wlan

        local essid = data_stdout:match("SSID: (.-)\n") or "N/A"
        local bitrate = data_stdout:match("tx bitrate: (.+/s)") or "N/A"

        local strength = tonumber(strength_stdout) or 0

        local healthy = not health_stdout:match("Connected but no internet")

        awesome.emit_signal(
          "daemon::network::status::wireless",
          interface,
          healthy,
          essid,
          bitrate,
          strength
        )
      end)
    end)
  end)
end


-- Emit wired connection status
local emit_wired_status = function()
  awful.spawn.easy_async_with_shell(healthcheck_script, function(stdout)
    local interface = Network_Interfaces.lan
    local healthy = not stdout:match("Connected but no internet")

    awesome.emit_signal(
      "daemon::network::status::wired",
      interface,
      healthy
    )
  end)
end


-- Emit wireless connected
local emit_wireless_connected = function ()
  awful.spawn.easy_async_with_shell(wireless_data_script, function(data_stdout)
    local interface = Network_Interfaces.lan
    local essid = data_stdout:match("SSID: (.-)\n") or "N/A"

    awesome.emit_signal(
      "daemon::network::connected::wireless",
      interface,
      essid
    )
  end)
end


-- Emit wired connected
local emit_wired_connected = function ()
  local interface = Network_Interfaces.lan

  awesome.emit_signal(
    "daemon::network::connected::wired",
    interface
  )
end


-- Emit network disconnected
local emit_disconnected = function ()
  if network_mode == nil then return end

  local interface = ""

  if network_mode == "wired" then
    interface = Network_Interfaces.lan
  else
    interface = Network_Interfaces.wlan
  end

  awesome.emit_signal(
    "daemon::network::disconnected::" .. network_mode,
    interface
  )
end


-- Main script
local check_network = function()
  awful.spawn.easy_async_with_shell(network_mode_script, function(stdout)
    if stdout:match("No internet connection") then
      if network_mode ~= nil then emit_disconnected() end
      network_mode = nil
    elseif stdout:match("wireless") then
      if network_mode ~= "wireless" then emit_wireless_connected() end
      network_mode = "wireless"
      emit_wireless_status()
    elseif stdout:match("wired") then
      if network_mode ~= "wired" then emit_wired_connected() end
      network_mode = "wired"
      emit_wired_status()
    end
  end)
end


-- ========================================
-- Initialization
-- ========================================

gears.timer {
  timeout = update_interval,
  autostart = true,
  call_now = true,
  callback = check_network,
}
