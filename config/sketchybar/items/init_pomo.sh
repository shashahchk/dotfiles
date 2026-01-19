#!/bin/bash

echo "initializing pomo"

# Main pomo item
sketchybar --add item pomo right \
	   --set pomo script="${PLUGIN_DIR}/pomo.sh" \
	    label.color="0xffaaffaa" \
           label="🍅" \
           label.drawing=on \
	   update_freq=1 \
	   updates=on \
	   popup.drawing=off \
	   popup.align=right \
	   popup.height=20 \
	   --subscribe pomo mouse.clicked mouse.exited mouse.entered

# Stats popup items
sketchybar --add item pomo.stats.header popup.pomo \
	   --set pomo.stats.header \
	    label="🍅 Pomodoro Stats" \
	    label.font="Hack Nerd Font:Bold:12.0" \
	    label.padding_left=10 \
	    label.padding_right=10 \
	    icon.drawing=off \
	    background.padding_left=5 \
	    background.padding_right=5

sketchybar --add item pomo.stats.total popup.pomo \
	   --set pomo.stats.total \
	    label="Total: 0 sessions" \
	    label.font="Hack Nerd Font:Regular:11.0" \
	    label.padding_left=10 \
	    label.padding_right=10 \
	    icon.drawing=off \
	    background.padding_left=5 \
	    background.padding_right=5

sketchybar --add item pomo.stats.today popup.pomo \
	   --set pomo.stats.today \
	    label="Today: 0 sessions" \
	    label.font="Hack Nerd Font:Regular:11.0" \
	    label.padding_left=10 \
	    label.padding_right=10 \
	    icon.drawing=off \
	    background.padding_left=5 \
	    background.padding_right=5

sketchybar --add item pomo.stats.week popup.pomo \
	   --set pomo.stats.week \
	    label="This Week: 0 sessions" \
	    label.font="Hack Nerd Font:Regular:11.0" \
	    label.padding_left=10 \
	    label.padding_right=10 \
	    icon.drawing=off \
	    background.padding_left=5 \
	    background.padding_right=5

sketchybar --add item pomo.stats.time popup.pomo \
	   --set pomo.stats.time \
	    label="Time: 0m" \
	    label.font="Hack Nerd Font:Regular:11.0" \
	    label.padding_left=10 \
	    label.padding_right=10 \
	    icon.drawing=off \
	    background.padding_left=5 \
	    background.padding_right=5
           
