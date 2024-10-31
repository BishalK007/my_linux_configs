#!/bin/sh

# ----------------------------------------
# Volume Control Script for Waybar using PipeWire (wpctl)
# ----------------------------------------

TEMP_FILE="/tmp/last_volume_for_waybar_script"
VOLUME_OUTPUT=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
VOLUME=$(echo "$VOLUME_OUTPUT" | awk '{print $2}')
VOLUME_PERCENT=$(awk -v vol="$VOLUME" 'BEGIN { printf "%.0f", vol * 100 }')
VOLUME_LIMIT="1.5" # 1 -> 100%, 1.5 -> 150% like that

# Check if last volume temp file exists, and read it
LAST_VOLUME=$(cat "$TEMP_FILE" 2>/dev/null || echo "0.5")

# Function to display current volume with icon for Waybar
get_volume() {
    if [[ "$VOLUME" == "0.00" ]]; then
        ICON=""  # Mute icon
    elif [[ "$VOLUME" < 0.3 ]]; then
        ICON=""  # Low volume icon
    elif [[ "$VOLUME" < 0.7 ]]; then
        ICON=""  # Medium volume icon
    else
        ICON=" "   # High volume icon
    fi
    printf '%s %d%%\n' "$ICON" "$VOLUME_PERCENT"
}

# Handle command-line arguments
case "$1" in
    --get-volume)
        get_volume
        ;;
    --increase-volume)
        wpctl set-volume -l "$VOLUME_LIMIT" @DEFAULT_AUDIO_SINK@ 5%+
        # SIGNAL FOR UPDATE
        pkill -RTMIN+"$VOLUME_WAYBAR_UPDATE_SIGNAL" waybar
        ;;
    --decrease-volume)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        # SIGNAL FOR UPDATE
        pkill -RTMIN+"$VOLUME_WAYBAR_UPDATE_SIGNAL" waybar
        ;;
    --mute-toggle)
        if [[ "$VOLUME" == "0.00" ]]; then
            wpctl set-volume -l "$VOLUME_LIMIT" @DEFAULT_AUDIO_SINK@ "$LAST_VOLUME"
        else
            echo "$VOLUME" > "$TEMP_FILE"
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%
        fi
        # SIGNAL FOR UPDATE
        pkill -RTMIN+"$VOLUME_WAYBAR_UPDATE_SIGNAL" waybar
        ;;
    *)
        echo "Usage: $0 {--get-volume | --increase-volume | --decrease-volume | --mute-toggle}"
        ;;
esac
