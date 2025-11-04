#!/bin/bash
# Example: rofi/dmenu launcher for nvflux profiles

if ! command -v nvflux >/dev/null 2>&1; then
    notify-send "nvflux Error" "nvflux not installed"
    exit 1
fi

# Detect menu launcher
if command -v rofi >/dev/null 2>&1; then
    MENU="rofi -dmenu -p GPU"
elif command -v dmenu >/dev/null 2>&1; then
    MENU="dmenu -p GPU:"
else
    echo "Error: Install rofi or dmenu" >&2
    exit 1
fi

current=$(nvflux status)
choice=$(echo -e "Performance\nBalanced\nPower Saver\nAuto/Reset" | $MENU)

case "$choice" in
    "Performance")
        nvflux performance && notify-send "GPU Profile" "Switched to Performance"
        ;;
    "Balanced")
        nvflux balanced && notify-send "GPU Profile" "Switched to Balanced"
        ;;
    "Power Saver")
        nvflux powersaver && notify-send "GPU Profile" "Switched to Power Saver"
        ;;
    "Auto/Reset")
        nvflux reset && notify-send "GPU Profile" "Reset to Auto"
        ;;
esac