#!/bin/bash

echo "initializing pomo"

sketchybar --add item pomo right \
	   --set pomo script="${PLUGIN_DIR}/pomo.sh status" \
	    label.color="0xffaaffaa"
	   label="start" \
           label.drawing=on \
	   update_freq=1 \
	   updates=on \
	   click_script="${PLUGIN_DIR}/pomo.sh click" \
	   --subscribe pomo mouse.clicked
           
