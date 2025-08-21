#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/helpers/constants.sh"
echo -e "space windows\n" >> $LOG_FILE
AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')
AEROSPACE_EMPTY_WORKSPACES=$(aerospace list-workspaces --monitor focused  --empty | awk '{print $1}')

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused | awk '{print $1}')
reload_workspace_icon() {
	echo "reload workspace icon for workspaces" "$@" >> $LOG_FILE
  LABEL_HIGHLIGHT=true
  ICON_HIGHLIGHT=true
  display=$AEROSPACE_FOCUSED_MONITOR
  BACKGROUND_BORDER_COLOR=$BLUE

  if [ "$@" != "$FOCUSED_WORKSPACE"  ]; then
    ICON_HIGHLIGHT=false
    LABEL_HIGHLIGHT=false
    BACKGROUND_BORDER_COLOR=$TRANSPARENT
  fi

  sketchybar --set "space.$@" display=$display icon.highlight=$ICON_HIGHLIGHT background.border_color=$BACKGROUND_BORDER_COLOR label.highlight=$LABEL_HIGHLIGHT
  apps=$(aerospace list-windows --workspace "$@" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
  icon_strip=$(source "$CONFIG_DIR/helpers/get_space_icons.sh")

  if echo "$AEROSPACE_EMPTY_WORKSPACES" | grep -q "$@" && [ "$@" != "$FOCUSED_WORKSPACE" ]; then
    display=0
  fi
  echo "space.$@" >> $LOG_FILE

  sketchybar --set "space.$@" label="$icon_strip" 
}

if [ "$SENDER" = "aerospace_workspace_change" ]; then
echo "focused workspace $FOCUSED_WORKSPACE" >> $LOG_FILE
echo "previous focused workspace $PREV_FOCUSED_WORKSPACE" >> $LOG_FILE
    reload_workspace_icon "$PREV_FOCUSED_WORKSPACE" &
    reload_workspace_icon "$FOCUSED_WORKSPACE" &
fi

if [ "$SENDER" = "space_windows_change" ]; then
  echo "space windows change $FOCUSED_WORKSPACE">> $LOG_FILE
  reload_workspace_icon "$FOCUSED_WORKSPACE"
fi