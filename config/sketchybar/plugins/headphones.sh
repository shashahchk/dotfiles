#!/bin/bash

# TODO: rewrite the whole thing what is this hahahhahah
get_devices() {
	DEVICES="$(system_profiler SPBluetoothDataType -json -detailLevel basic 2>/dev/null \
	| jq -r '.SPBluetoothDataType[0].device_connected[] | to_entries[] | "\(.key) \(.value.device_minorType)"')"

	echo $DEVICES
}

# if [ "$DEVICES" = "" ]; then
#   sketchybar -m --set $NAME drawing=off
# else
#   sketchybar -m --set $NAME drawing=on
#   # Left
#   LEFT="$(defaults read /Library/Preferences/com.apple.Bluetooth | grep BatteryPercentLeft | tr -d \; | awk '{ printf("%02d", $3) }')"%
#
#   # Right
#   RIGHT="$(defaults read /Library/Preferences/com.apple.Bluetooth | grep BatteryPercentRight | tr -d \; | awk '{ printf("%02d", $3) }')"%
#
#   # Case
#   CASE="$(defaults read /Library/Preferences/com.apple.Bluetooth | grep BatteryPercentCase | tr -d \; | awk '{ printf("%02d", $3) }')"%
#
#   echo $CASE
#
#   if [ $LEFT = 00% ]; then
#     LEFT="-"
#   fi
#
#   if [ $RIGHT = 00% ]; then
#     RIGHT="-"
#   fi
#
#   if [ $CASE = 00% ]; then
#     CASE="-"
#   fi
MAIN_HEADSET="Obsidian"
DEVICES=$(get_devices)

if [ "$DEVICES" != "" ]; then
    sketchybar -m --set $NAME label="$DEVICES" click_script="blueutil --disconnect \"$MAIN_HEADSET\""
else 
    sketchybar -m --set $NAME label="No device"  click_script="blueutil --connect \"$MAIN_HEADSET\""
fi
  # sketchybar -m --set $NAME label="$LEFT $CASE $RIGHT"
  # echo "$LEFT $CASE $RIGHT"
# fi
