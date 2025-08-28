#!/bin/bash

active_pomo=(
	script="$CONFIG_DIR/plugins/active_pomo.sh" 
	update_freq=1
	updates=on
)

if [ $SENDER = "mouse.clicked" ]; then
	sketchybar --set pomo "${active_pomo[@]}" 
	exit
fi

inactive_pomo=(
        script="$CONFIG_DIR/plugins/pomo.sh"
        label="start"
        label.color="0xffffffff"
        updates=off
)
rm -f "/tmp/sketchybar_pomo_start"

sketchybar --set pomo "${inactive_pomo[@]}"


