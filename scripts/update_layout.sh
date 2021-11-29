#! /bin/bash

#
# update_layout.sh
# Updates hammerspoon's active layout widget by querying yabai
#

is_window_floating=$(yabai -m query --windows --window | jq '.floating')

if [[ $is_window_floating = 1 ]]; then
  hs -c "Layouts:update(\"float\")"
  exit 0
fi

space_layout=$(yabai -m query --spaces --space | jq '.type')

hs_cmd="Layouts:update($space_layout)"

hs -c "$hs_cmd"
