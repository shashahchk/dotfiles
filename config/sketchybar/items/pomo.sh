#!/bin/bash

echo "loading pomo"

sketchybar --add item pomo right \
	   --set pomo script="${PLUGIN_DIR}/pomo.sh" label.drawing=on \
	   --subscribe pomo mouse.clicked
