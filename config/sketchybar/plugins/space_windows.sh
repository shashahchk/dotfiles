#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/helpers/constants.sh"
echo -e "space windows\n" >> $LOG_FILE
AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')
AEROSPACE_EMPTY_WORKSPACES=$(aerospace list-workspaces --monitor focused  --empty | awk '{print $1}')

reload_workspace_icon() {
	echo "reload workspace icon" "$@" >> $LOG_FILE
  apps=$(aerospace list-windows --workspace "$@" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
  icon_strip=$(source "$CONFIG_DIR/helpers/get_space_icons.sh")

  display=$AEROSPACE_FOCUSED_MONITOR
  if echo "$AEROSPACE_EMPTY_WORKSPACES" | grep -q "$@"; then
    display=0
  fi
  echo "space.$@" >> $LOG_FILE
  sketchybar --set "space.$@" label="$icon_strip" display=$display
}

if [ "$SENDER" = "aerospace_workspace_change" ]; then
echo "focused workspace $FOCUSED_WORKSPACE" >> $LOG_FILE
echo "previous focused workspace $PREV_FOCUSED_WORKSPACE" >> $LOG_FILE

    reload_workspace_icon "$FOCUSED_WORKSPACE" 
		sketchybar --set space.$FOCUSED_WORKSPACE label.highlight=true \
		    icon.highlight=true \
		    background.border_color=$GREY
	    sketchybar --set space.$PREV_FOCUSED_WORKSPACE label.highlight=false \
		    icon.highlight=false \
		    background.border_color=$BACKGROUND_2
    reload_workspace_icon "$PREV_FOCUSED_WORKSPACE"
  # sketchybar --set space.$AEROSPACE_FOCUSED_WORKSPACE display=$AEROSPACE_FOCUSED_MONITOR
fi

if [ "$SENDER" = "space_windows_change" ]; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused | awk '{print $1}')
  echo "space windows change $FOCUSED_WORKSPACE">> $LOG_FILE
  reload_workspace_icon "$FOCUSED_WORKSPACE"
fi