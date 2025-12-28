#!/bin/bash

STATE_FILE="/tmp/sketchybar_pomo_state"
DEFAULT_DURATION=1800 # 30 minutes
BREAK_DURATION=300

# ──────────────────────────────
# Load state into local variables
# ──────────────────────────────
load_state() {
    if [ -f "$STATE_FILE" ]; then
        # shellcheck disable=SC1090
        source "$STATE_FILE"
    else
        state="inactive"
        start_time=0
        duration=$DEFAULT_DURATION
    fi
}

# ──────────────────────────────
# Save state to file
# ──────────────────────────────
save_state() {
    local state="$1"
    local start_time="${2:-0}"
    local duration="${3:-$DEFAULT_DURATION}"

    cat > "$STATE_FILE" <<EOF
state=$state
start_time=$start_time
duration=$duration
EOF
}

# ──────────────────────────────
# Update SketchyBar appearance
# ──────────────────────────────
update_appearance() {
    local state="$1"
    local start_time="$2"
    local duration="$3"
    local label color

    case $state in 
	    active)
		local now=$(date +%s)
		local elapsed=$(( now - start_time ))
		local remaining=$(( duration - elapsed ))

		if [ $remaining -le 0 ]; then
		    # Timer finished
		     start_time=$(date +%s)
		     duration=$BREAK_DURATION
		    save_state "break" "$start_time" "$duration"

		    terminal-notifier -title "Pomodoro Complete" -message "Take a break! 🍅" -sound default
		else
			label="$(printf "%02d:%02d" $((remaining/60)) $((remaining%60)))"
			color="0xffffffff"

			sketchybar --set pomo label="$label" color="$color" updates=on
		fi
		;;
	     break)
		local now=$(date +%s)
		local elapsed=$(( now - start_time ))
		local remaining=$(( duration - elapsed ))

		if [ $remaining -le 0 ]; then
		    save_state "inactive"

		    sketchybar --set pomo label="🍅" updates=off

		    terminal-notifier -title "Break over" -message "Get to work!" -sound default

		    return
		else
			sketchybar --set pomo label="🍌 $(printf "%02d:%02d" $((remaining/60)) $((remaining%60)))" color="0xffffaaaa"
		fi
		;;
	     inactive)
		sketchybar --set pomo label="🍅" label.color="0xffffffff" updates=off
		;;
   esac
 }

# ──────────────────────────────
# Main event handling
# ──────────────────────────────
# load cur state from file
load_state

case "$SENDER" in
    "mouse.clicked")
        if [ "$state" = "active" ] || [ "$state" = "break" ]; then
            # Stop timer
            save_state "inactive"
            update_appearance "inactive"
        else
	    # was inactive
             start_time=$(date +%s)
             duration=$DEFAULT_DURATION
            save_state "active" "$start_time" "$duration"
            update_appearance "active" "$start_time" "$duration"
        fi
        ;;

    "routine") 
        # Called by SketchyBar update polling
        update_appearance "$state" "$start_time" "$duration"
        ;;

    *)
        echo "Unknown sender: $SENDER"
        ;;
esac

