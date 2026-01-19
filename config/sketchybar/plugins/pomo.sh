#!/bin/bash

STATE_FILE="/tmp/sketchybar_pomo_state"
STATS_FILE="/tmp/sketchybar_pomo_stats"
ARCHIVE_FILE="$HOME/.sketchybar_pomo_archive"
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
# Get Monday of current week (macOS compatible)
# ──────────────────────────────
get_week_start() {
    # macOS uses -v flag, Linux uses -d flag
    if date -v-Monday +%Y-%m-%d >/dev/null 2>&1; then
        # macOS
        date -v-Monday +%Y-%m-%d
    else
        # Linux fallback
        date -d "last Monday" +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d
    fi
}

# ──────────────────────────────
# Load stats from file
# ──────────────────────────────
load_stats() {
    if [ -f "$STATS_FILE" ]; then
        # shellcheck disable=SC1090
        source "$STATS_FILE"
    else
        total_sessions=0
        total_time=0
        today_date=$(date +%Y-%m-%d)
        today_sessions=0
        week_start=$(get_week_start)
        week_sessions=0
        save_stats
    fi
}

# ──────────────────────────────
# Save stats to file
# ──────────────────────────────
save_stats() {
    cat > "$STATS_FILE" <<EOF
total_sessions=$total_sessions
total_time=$total_time
today_date=$today_date
today_sessions=$today_sessions
week_start=$week_start
week_sessions=$week_sessions
EOF
}

# ──────────────────────────────
# Archive stats to history file
# ──────────────────────────────
archive_stats() {
    local archive_type="$1"  # "week" or "day"
    local period_start="$2"  # The start date of the period
    local sessions="$3"      # Number of sessions
    local time_seconds="$4"  # Time in seconds
    
    # Format time
    local hours=$((time_seconds / 3600))
    local minutes=$(((time_seconds % 3600) / 60))
    local time_str
    if [ $hours -gt 0 ]; then
        time_str="${hours}h ${minutes}m"
    else
        time_str="${minutes}m"
    fi
    
    # Calculate period end date
    local period_end
    if [ "$archive_type" = "week" ]; then
        # Week ends on Sunday (6 days after Monday)
        # Try macOS date command first
        if command -v gdate >/dev/null 2>&1; then
            # GNU date (if installed via homebrew)
            period_end=$(gdate -d "$period_start +6 days" +%Y-%m-%d 2>/dev/null || echo "$period_start")
        elif date -j -f "%Y-%m-%d" "$period_start" +%s >/dev/null 2>&1; then
            # macOS date - convert to epoch, add 6 days, convert back
            local epoch=$(date -j -f "%Y-%m-%d" "$period_start" +%s 2>/dev/null)
            if [ -n "$epoch" ] && [ "$epoch" -gt 0 ]; then
                epoch=$((epoch + 6 * 24 * 60 * 60))
                period_end=$(date -r "$epoch" +%Y-%m-%d 2>/dev/null || echo "$period_start")
            else
                period_end="$period_start"
            fi
        elif date -d "$period_start +6 days" +%Y-%m-%d >/dev/null 2>&1; then
            # Linux date
            period_end=$(date -d "$period_start +6 days" +%Y-%m-%d 2>/dev/null || echo "$period_start")
        else
            period_end="$period_start"
        fi
    else
        # Day
        period_end="$period_start"
    fi
    
    local timestamp=$(date +%Y-%m-%d\ %H:%M:%S)
    
    # Append to archive file
    {
        echo "[$timestamp] $archive_type: $period_start to $period_end"
        echo "  Sessions: $sessions"
        echo "  Time: $time_str ($time_seconds seconds)"
        echo ""
    } >> "$ARCHIVE_FILE"
}

# ──────────────────────────────
# Record completed pomo session
# ──────────────────────────────
record_session() {
    load_stats
    
    local current_date=$(date +%Y-%m-%d)
    local current_week_start=$(get_week_start)
    
    # Archive and reset today's count if it's a new day
    if [ "$current_date" != "$today_date" ] && [ "$today_sessions" -gt 0 ]; then
        # Archive yesterday's stats
        local yesterday_time=$((today_sessions * DEFAULT_DURATION))
        archive_stats "day" "$today_date" "$today_sessions" "$yesterday_time"
        
        today_date=$current_date
        today_sessions=0
    fi
    
    # Archive and reset week's count if it's a new week
    if [ "$current_week_start" != "$week_start" ] && [ "$week_sessions" -gt 0 ]; then
        # Archive last week's stats
        local last_week_time=$((week_sessions * DEFAULT_DURATION))
        archive_stats "week" "$week_start" "$week_sessions" "$last_week_time"
        
        week_start=$current_week_start
        week_sessions=0
    fi
    
    # Increment counters
    total_sessions=$((total_sessions + 1))
    today_sessions=$((today_sessions + 1))
    week_sessions=$((week_sessions + 1))
    total_time=$((total_time + DEFAULT_DURATION))
    
    save_stats
    update_stats_display
}

# ──────────────────────────────
# Update stats display in popup
# ──────────────────────────────
update_stats_display() {
    load_stats
    
    # Format total time as hours and minutes
    local hours=$((total_time / 3600))
    local minutes=$(((total_time % 3600) / 60))
    local time_str
    if [ $hours -gt 0 ]; then
        time_str="${hours}h ${minutes}m"
    else
        time_str="${minutes}m"
    fi
    
    sketchybar --set pomo.stats.total label="Total: $total_sessions sessions" \
               --set pomo.stats.today label="Today: $today_sessions sessions" \
               --set pomo.stats.week label="This Week: $week_sessions sessions" \
               --set pomo.stats.time label="Time: $time_str"
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
		    # Timer finished - record the session
		    record_session
		    
		    # Start break
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
        # Check if right-click (button 2) or left-click
        if [ "$BUTTON" = "2" ] || [ "$BUTTON" = "right" ]; then
            # Right-click: toggle stats popup
            update_stats_display
            local current_state=$(sketchybar --query pomo | jq -r '.popup.drawing' 2>/dev/null || echo "off")
            if [ "$current_state" = "on" ]; then
                sketchybar --set pomo popup.drawing=off
            else
                sketchybar --set pomo popup.drawing=on
            fi
        else
            # Left-click: start/stop timer
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
        fi
        ;;

    "routine")
        # Called by SketchyBar update polling
        update_appearance "$state" "$start_time" "$duration"
        
        # Check for day/week changes and archive if needed (even when not recording sessions)
        load_stats
        local current_date=$(date +%Y-%m-%d)
        local current_week_start=$(get_week_start)
        
        # Archive and reset today's count if it's a new day
        if [ "$current_date" != "$today_date" ] && [ "$today_sessions" -gt 0 ]; then
            local yesterday_time=$((today_sessions * DEFAULT_DURATION))
            archive_stats "day" "$today_date" "$today_sessions" "$yesterday_time"
            today_date=$current_date
            today_sessions=0
            save_stats
        fi
        
        # Archive and reset week's count if it's a new week
        if [ "$current_week_start" != "$week_start" ] && [ "$week_sessions" -gt 0 ]; then
            local last_week_time=$((week_sessions * DEFAULT_DURATION))
            archive_stats "week" "$week_start" "$week_sessions" "$last_week_time"
            week_start=$current_week_start
            week_sessions=0
            save_stats
        fi
        
        # Refresh stats display if popup is open (to handle day/week changes)
        local popup_state=$(sketchybar --query pomo | jq -r '.popup.drawing' 2>/dev/null || echo "off")
        if [ "$popup_state" = "on" ]; then
            update_stats_display
        fi
        ;;

    "mouse.exited")
        # Hide popup when mouse leaves the pomo item
        sketchybar --set pomo popup.drawing=off
        ;;

    "mouse.entered")
        # Show stats on hover
        update_stats_display
        sketchybar --set pomo popup.drawing=on
        ;;

    *)
        echo "Unknown sender: $SENDER"
        ;;
esac

