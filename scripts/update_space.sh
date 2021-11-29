#! /bin/bash

#
# update_space.sh
# Updates hammerspoon's active space widget by querying yabai
#

current_space=$(yabai -m query --spaces --space | jq '.index')

hs_cmd="Spaces:update($current_space)"

hs -c "$hs_cmd"
