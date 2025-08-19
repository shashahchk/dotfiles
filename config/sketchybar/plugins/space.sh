#!/bin/bash

source "$CONFIG_DIR/helpers/constants.sh"
echo space.sh $'FOCUSED_WORKSPACE': $FOCUSED_WORKSPACE, $'SELECTED': $SELECTED, NAME: $NAME, SENDER: $SENDER  >> $LOG_FILE
# echo "focused workspace" $FOCUSED_WORKSPACE

# most likely don't need this as we'll only use one mac "space"
# update() {
#   # 처음 시작에만 작동하기 위해서
#   # 현재 forced, space_change 이벤트가 동시에 발생하고 있다.
#   if [ "$SENDER" = "space_change" ]; then
#     #echo space.sh $'FOCUSED_WORKSPACE': $FOCUSED_WORKSPACE, $'SELECTED': $SELECTED, NAME: $NAME, SENDER: $SENDER, INFO: $INFO  >> ~/aaaa
#     #echo $(aerospace list-workspaces --focused) >> ~/aaaa
#     source "$CONFIG_DIR/colors.sh"
#     COLOR=$BACKGROUND_2
#     if [ "$SELECTED" = "true" ]; then
#       COLOR=$GREY
#     fi
#     # sketchybar --set $NAME icon.highlight=$SELECTED \
#     #                        label.highlight=$SELECTED \
#     #                        background.border_color=$COLOR
    
#     sketchybar --set space.$(aerospace list-workspaces --focused) icon.highlight=true \
#                       label.highlight=true \
#                       background.border_color=$GREY
#   fi
# }

set_space_label() {
  sketchybar --set $NAME icon="$@"
}

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    echo ''
  else
    if [ "$MODIFIER" = "shift" ]; then
      SPACE_LABEL="$(osascript -e "return (text returned of (display dialog \"Give a name to space $NAME:\" default answer \"\" with icon note buttons {\"Cancel\", \"Continue\"} default button \"Continue\"))")"
      if [ $? -eq 0 ]; then
        if [ "$SPACE_LABEL" = "" ]; then
          set_space_label "${NAME:6}"
        else
          set_space_label "${NAME:6} ($SPACE_LABEL)"
        fi
      fi
    else
      aerospace workspace ${NAME#*.}
    fi
  fi
}

# echo plugin_space.sh $SENDER >> ~/aaaa

  if [ "$SENDER" = "mouse.clicked" ]; then
    mouse_clicked
  fi

# windows workspace
# echo AEROSPACE_PREV_WORKSPACE: $AEROSPACE_PREV_WORKSPACE, \ AEROSPACE_FOCUSED_WORKSPACE: $AEROSPACE_FOCUSED_WORKSPACE \
#  SELECTED: $SELECTED \
#  BG2: $BG2 \
#  INFO: $INFO \
#  SENDER: $SENDER \
#  NAME: $NAME \
#   >> ~/aaaa

source "$CONFIG_DIR/colors.sh"

reload_workspace_icon() {
	echo "reload workspace icon" "$@" >> $LOG_FILE
  apps=$(aerospace list-windows --workspace "$@" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
  icon_strip=$(source "$CONFIG_DIR/helpers/get_space_icons.sh")

  sketchybar --set space.$@ label="$icon_strip"
}

if [ "$SENDER" = "aerospace_workspace_change" ]; then
	if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
		echo "setting background border color"
    
		sketchybar --set $NAME label.highlight=true \
		    icon.highlight=true \
		    background.border_color=$GREY
    reload_workspace_icon "$FOCUSED_WORKSPACE"
    reload_workspace_icon "$PREV_FOCUSED_WORKSPACE"
	else
	    sketchybar --set $NAME label.highlight=false \
		    icon.highlight=false \
		    background.border_color=$BACKGROUND_2
	fi

  # AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')
  # ## focused 된 모니터에 space 상태 보이게 설정
  # for i in $AEROSPACE_FOCUSED_MONITOR; do
  #   sketchybar --set space.$i display=$AEROSPACE_FOCUSED_MONITOR
  # done

  AEROSPACE_EMPTY_WORKSPACES=$(aerospace list-workspaces --monitor focused  --empty | awk '{print $1}')
  for i in $AEROSPACE_EMPTY_WORKSPACES; do
    sketchybar --set space.$i display=0
  done

  # sketchybar --set space.$AEROSPACE_FOCUSED_WORKSPACE display=$AEROSPACE_FOCUSED_MONITOR
fi

if [ "$SENDER" = "space_windows_change" ]; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused | awk '{print $1}')
  echo "space windows change $FOCUSED_WORKSPACE">> $LOG_FILE
  reload_workspace_icon "$FOCUSED_WORKSPACE"
fi