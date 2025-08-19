#!/bin/sh

for m in $(aerospace list-monitors | awk '{print $1}'); do
  for i in $(aerospace list-workspaces --monitor $m); do
    BACKGROUND_BORDER_COLOR=$BACKGROUND_2
    echo "focused aerospace workspace" $(aerospace list-workspaces --focused)
    if [ "$i" = "$(aerospace list-workspaces --focused)" ]; then
	    BACKGROUND_BORDER_COLOR=$GREY
    fi
    sid=$i
    space=(
      space="$sid"
      icon="$sid"
      icon.highlight_color=$RED
      icon.padding_left=10
      icon.padding_right=10
      display=$m
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
                --subscribe space.$sid mouse.clicked aerospace_workspace_change

    apps=$(aerospace list-windows --workspace $sid | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

    icon_strip=" "
    if [ "${apps}" != "" ]; then
      while read -r app
      do
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
      done <<< "${apps}"
    else
      icon_strip=" —"
    fi

    sketchybar --set space.$sid label="$icon_strip"
  done

  # for i in $(aerospace list-workspaces --monitor $m --empty); do
  #   sketchybar --set space.$i display=0
  # done
  
done
