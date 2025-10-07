#!/bin/bash

STATE_FILE="/tmp/sketchybar_pomo_state"
DEFAULT_DURATION=1800 # 30 minutes

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

    if [ "$state" = "active" ]; then
        local now=$(date +%s)
        local elapsed=$(( now - start_time ))
        local remaining=$(( duration - elapsed ))

        if [ $remaining -le 0 ]; then
            # Timer finished
            save_state "inactive"
            sketchybar --set pomo label="start" updates=off

            return
        fi

        label="$(printf "%02d:%02d" $((remaining/60)) $((remaining%60)))"
        color="0xffffaaaa"
    else
        label="start"
        color="0xffffffff"
    fi

    sketchybar --set pomo label="$label" label.color="$color"
}

# ──────────────────────────────
# Main event handling
# ──────────────────────────────
case "$1" in
    click)
        load_state
        if [ "$state" = "active" ]; then
            save_state "inactive"
            sketchybar --set pomo updates=off
            update_appearance "inactive"
        else
            start_time=$(date +%s)
            duration=$DEFAULT_DURATION
            save_state "active" "$start_time" "$duration"
            sketchybar --set pomo updates=on
            update_appearance "active" "$start_time" "$duration"
        fi
        ;;

    status)
        load_state
        update_appearance "$state" "$start_time" "$duration"
        ;;

    *)
        echo "Usage: $0 [click|status]"
        ;;
esac

