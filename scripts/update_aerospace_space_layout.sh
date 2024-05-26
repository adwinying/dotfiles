#! /bin/bash

#
# update_aerospace_space_layout.sh
# Updates hammerspoon's active space/layout widget by querying aerospace
#

spaces_cmd="Spaces:update($AEROSPACE_FOCUSED_WORKSPACE)"
layout_cmd="Layouts:update()"

hs -c "$spaces_cmd"
# hs -c "$layout_cmd"
