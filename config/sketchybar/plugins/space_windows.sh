#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/helpers/constants.sh"
echo -e "space windows\n" >> $LOG_FILE
# AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')
# TODO: Optimize and not use --all
AEROSPACE_EMPTY_WORKSPACES=$(aerospace list-workspaces --all focused  --empty | awk '{print $1}')

reload_workspace_icon() {
	echo "reload workspace icon for workspaces" "$@" >> $LOG_FILE
  LABEL_HIGHLIGHT=true
  ICON_HIGHLIGHT=true
  BACKGROUND_BORDER_COLOR=$WHITE

  if [ "$@" != "$FOCUSED_WORKSPACE"  ]; then
    ICON_HIGHLIGHT=false
    LABEL_HIGHLIGHT=false
    BACKGROUND_BORDER_COLOR=$TRANSPARENT
  fi

  sketchybar --set "space.$@" icon.highlight=$ICON_HIGHLIGHT background.border_color=$BACKGROUND_BORDER_COLOR label.highlight=$LABEL_HIGHLIGHT
  apps=$(aerospace list-windows --workspace "$@" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
  icon_strip=$(source "$CONFIG_DIR/helpers/get_space_icons.sh")

  echo "space.$@" >> $LOG_FILE

  sketchybar --set "space.$@" label="$icon_strip" 
}

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused | awk '{print $1}')
if [ "$SENDER" = "aerospace_workspace_change" ]; then
  # set visibility first before highlight + icon update to prevent glitch
  if echo "$AEROSPACE_EMPTY_WORKSPACES" | grep -q "$PREV_FOCUSED_WORKSPACE"; then
    sketchybar --set "space.$PREV_FOCUSED_WORKSPACE" display=0
  fi

  reload_workspace_icon "$PREV_FOCUSED_WORKSPACE" &
  reload_workspace_icon "$FOCUSED_WORKSPACE" &

  focused_ws_monitor_id=$(source "$CONFIG_DIR/helpers/get_monitor_for_workspace.sh" "$FOCUSED_WORKSPACE")

  sketchybar --set "space.$FOCUSED_WORKSPACE" display=$focused_ws_monitor_id
elif [[ "$SENDER" = "change_workspace_monitor" ]]; then
  sketchybar --set workspace.$TARGET_WORKSPACE display=$TARGET_MONITOR
elif [ "$SENDER" = "space_windows_change" ]; then
  echo "space windows change $FOCUSED_WORKSPACE">> $LOG_FILE
  reload_workspace_icon "$FOCUSED_WORKSPACE"
fi
