#!/bin/sh

# This custom event (triggered in ~/.config/aerospace/aerospace.toml) fires when
# a workspace is moved to a different monitor.
# It will include two variables:
# - TARGET_MONITOR: The system ID of the monitor the workspace was moved to (NOT aerospace ID)
# - TARGET_WORKSPACE: The ID of the workspace that is being moved
sketchybar --add event change_workspace_monitor

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
source "$CONFIG_DIR/helpers/constants.sh"

  for ws in $(aerospace list-workspaces --all); do
   monitor=$(source "$CONFIG_DIR/helpers/get_monitor_for_workspace.sh" "$ws")

   EMPTY_WORKSPACES=$(aerospace list-workspaces --monitor "$monitor" --empty)

   display="$monitor"

   echo "initializing ws $ws on monitor $monitor" >> $LOG_FILE

   if echo "$EMPTY_WORKSPACES" | grep -q "$ws" && [ "$ws" != "$FOCUSED_WORKSPACE" ]; then
      display=0
    fi
    BACKGROUND_BORDER_COLOR=$TRANSPARENT
    echo "focused aerospace workspace" $(aerospace list-workspaces --focused)
    if [ "$ws" = "$FOCUSED_WORKSPACE" ]; then
	    BACKGROUND_BORDER_COLOR=$WHITE
    fi
    sid=$ws
    space=(
      space="$sid"
      icon="$sid"
      icon.highlight_color=$BLUE
      # icon.padding_left=5
      # icon.padding_right=5
      display=$display
      padding_left=6
      padding_right=6
 # label.padding_right=18
      label.color=$GREY
      label.highlight_color=$WHITE
      label.font="$FONT:Regular:11.0"
      label.y_offset=-1
      # background.color=$BACKGROUND_1
 # background.border_color=$BACKGROUND_BORDER_COLOR
      script="$PLUGIN_DIR/space.sh $sid"
    )

    sketchybar --add space space.$sid left \
               --set space.$sid "${space[@]}" \
                --subscribe space.$sid mouse.clicked  


    # icon_strip=$(source "$CONFIG_DIR/helpers/get_space_icons.sh" "$ws")

    # sketchybar --set space.$sid label="$icon_strip"
done

# SF_FONT="SF Pro"

arrow_space_manager=(
  icon=􀆊
  icon.font="$FONT:Bold:16.0"
  padding_left=10
  padding_right=8
  label.drawing=off
  display=active
  icon.color=$TRANSPARENT # hidden
  script="$PLUGIN_DIR/space_windows.sh"
)

sketchybar --add item arrow_space_manager left               \
           --set arrow_space_manager "${arrow_space_manager[@]}"   \
           --subscribe arrow_space_manager aerospace_workspace_change space_windows_change change_workspace_monitor
