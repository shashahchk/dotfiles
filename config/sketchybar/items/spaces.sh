#!/bin/sh

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
source "$CONFIG_DIR/helpers/constants.sh"

for monitor in $(aerospace list-monitors | awk '{print $1}'); do
  for ws in $(aerospace list-workspaces --monitor $monitor); do
   EMPTY_WORKSPACES=$(aerospace list-workspaces --monitor $monitor --empty)
   display="$monitor"

   echo "initializing ws $ws on monitor $monitor" >> $LOG_FILE

   if echo "$EMPTY_WORKSPACES" | grep -q "$ws" && [ "$ws" != "$FOCUSED_WORKSPACE" ]; then
      display=0
    fi
    BACKGROUND_BORDER_COLOR=$BACKGROUND_2
    echo "focused aerospace workspace" $(aerospace list-workspaces --focused)
    if [ "$ws" = "$FOCUSED_WORKSPACE" ]; then
	    BACKGROUND_BORDER_COLOR=$GREY
    fi
    sid=$ws
    space=(
      space="$sid"
      icon="$sid"
      icon.highlight_color=$RED
      icon.padding_left=10
      icon.padding_right=10
      display=$display
      padding_left=2
      padding_right=2
      label.padding_right=20
      label.color=$GREY
      label.highlight_color=$WHITE
      label.font="sketchybar-app-font:Regular:16.0"
      label.y_offset=-1
      background.color=$BACKGROUND_1
      background.border_color=$BACKGROUND_BORDER_COLOR
      script="$PLUGIN_DIR/space.sh $sid"
    )

    sketchybar --add space space.$sid left \
               --set space.$sid "${space[@]}" \
                --subscribe space.$sid mouse.clicked 


    icon_strip=$(source "$CONFIG_DIR/helpers/get_space_icons.sh" "$ws")

    sketchybar --set space.$sid label="$icon_strip"
  done
done

SF_FONT="SF Pro"

arrow=(
  icon=􀆊
  icon.font="$SF_FONT:Heavy:16.0"
  padding_left=10
  padding_right=8
  label.drawing=off
  display=active
  icon.color=$WHITE
  script="$PLUGIN_DIR/space_windows.sh"
)

sketchybar --add item arrow left               \
           --set arrow "${arrow[@]}"   \
           --subscribe arrow aerospace_workspace_change space_windows_change