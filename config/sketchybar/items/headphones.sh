#!/bin/bash

sketchybar -m --add event bluetooth_change "com.apple.bluetooth.status" \
              --add item headphones right \
              --set headphones script="${PLUGIN_DIR}/headphones.sh" \
              --subscribe headphones bluetooth_change

