#!/bin/bash

# source "$CONFIG_DIR/colors.sh"
# source "$CONFIG_DIR/helpers/constants.sh"
# echo -e "space windows\n" >> $LOG_FILE

# TODO: check whether there's an event when new monitor is connected
#handle_multi_monitor_update() {
#  # TODO: move helper here to avoid spawning subshell
#  focused_ws_monitor_id=$(source "$CONFIG_DIR/helpers/get_monitor_for_workspace.sh" "$FOCUSED_WORKSPACE")
#  #
#  DISPLAY=$focused_ws_monitor_id

#  FOCUSED_MONITOR=$(aerospace list-monitors --mouse --format "%{monitor-appkit-nsscreen-screens-id}")
#   DISPLAY=${FOCUSED_MONITOR:0:1}
#  if [ -z "$DISPLAY" ]; then
#          echo "display not found for ws., ws $FOCUSED_WORKSPACE, monitor_id $focused_ws_monitor_id"
#	  echo "setting display to $DISPLAY"
#  fi
#  sketchybar --set "space.$FOCUSED_WORKSPACE" display=$DISPLAY

#}

handle_empty_workspaces() {
  if [ -n "$(aerospace list-windows --workspace "$PREV_FOCUSED_WORKSPACE" | head -n1)" ]; then
    return
  fi

  sketchybar --set "space.$PREV_FOCUSED_WORKSPACE" display=0
}

# FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused | awk '{print $1}')
case "$SENDER" in
  aerospace_workspace_change)
 # set visibility first before highlight + icon update to prevent glitch
    sketchybar \
    --set "space.$FOCUSED_WORKSPACE" icon.highlight=true label.highlight=true \
    --set "space.$PREV_FOCUSED_WORKSPACE" icon.highlight=false label.highlight=false

    handle_empty_workspaces
  # handle_multi_monitor_update  &
    ;;
  change_workspace_monitor)
    sketchybar --set workspace.$TARGET_WORKSPACE display=$TARGET_MONITOR
    ;;
esac
