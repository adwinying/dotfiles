#! /usr/bin/env bash

#
# powermenu.sh
# Show exit actions powered by rofi
#

action=$(printf "Lock\nLogout\nSuspend\nReboot\nPoweroff" | rofi -dmenu -i -p "")

case $action in
  Lock)
    gtklock ;;
  Logout)
    hyprctl dispatch exit ;;
  Suspend)
    systemctl suspend ;;
  Reboot)
    systemctl reboot ;;
  Poweroff)
    systemctl poweroff ;;
esac
