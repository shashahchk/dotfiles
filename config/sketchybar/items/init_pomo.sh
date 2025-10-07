#!/bin/bash

echo "initializing pomo"

sketchybar --add item pomo right \
	   --set pomo script="${PLUGIN_DIR}/pomo.sh" \
	    label.color="0xffaaffaa" \
	   label="start" \
           label.drawing=on \
	   update_freq=1 \
	   updates=on \
	   --subscribe pomo mouse.clicked
           
