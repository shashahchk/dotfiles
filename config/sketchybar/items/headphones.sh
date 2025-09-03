#!/bin/bash

sketchybar -m --add item headphones right \
              --set headphones script="${PLUGIN_DIR}/headphones.sh"
              --subscribe headphones bluetooth_change

