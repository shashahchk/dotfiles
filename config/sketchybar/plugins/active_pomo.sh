#!/bin/bash
inactive_pomo_script=(
        script="$CONFIG_DIR/plugins/pomo.sh"
)

if [ $SENDER = "mouse.clicked" ]; then
	sketchybar --set pomo "${inactive_pomo_script[@]}"
        exit
fi

TMP_FILE="/tmp/sketchybar_pomo_start"

if [ -f "$TMP_FILE" ]; then
  START_TIME=$(<"$TMP_FILE")
fi

write_time_to_file() {
  date +%s > "$TMP_FILE"
}

if [ -z "$START_TIME" ] || [ "$START_TIME" = "null" ]; then
  write_time_to_file
  START_TIME=$(<"$TMP_FILE")
fi

DURATION=5
NOW=$(date +%s)
ELAPSED=$(( NOW - START_TIME ))
REMAINING=$(( DURATION - ELAPSED ))

if [ $REMAINING -lt 0 ]; then
	REMAINING=0
	sketchybar --set pomo label.color="0xff00ff00"
	sketchybar --set pomo "${inactive_pomo_script[@]}"
	exit
fi

MINUTES=$(( REMAINING / 60 ))
SECONDS=$(( REMAINING % 60 ))

LABEL=$(printf "%02d:%02d" $MINUTES $SECONDS)

sketchybar --set pomo label="$LABEL"


