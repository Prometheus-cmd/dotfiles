#!/bin/bash

# ── Gaming Mode Toggle for Hyprland ──────────────────────────────────────────
STATE_FILE="/tmp/hypr_gaming_mode"
NOTIFY="notify-send -t 3000 -i input-gaming"

enable_gaming_mode() {
    touch "$STATE_FILE"

    # ── Kill compositor eye-candy ─────────────────────────────────────────────
    pkill -x waybar
    pkill -x awww
    pkill -x hyprpaper
    pkill -x mpvpaper
    pkill -x wlogout
    pkill -x swaync          # comment out if you want notifs while gaming

    # ── Strip Hyprland animations & blur ─────────────────────────────────────
    hyprctl keyword animations:enabled 0
    hyprctl keyword decoration:blur:enabled 0
    hyprctl keyword decoration:shadow:enabled 0
    hyprctl keyword decoration:inactive_opacity 1
    hyprctl keyword decoration:active_opacity 1
    hyprctl keyword misc:vfr 0

    # ── CPU governor → performance ────────────────────────────────────────────
    # Requires: pacman -S cpupower + sudoers rule (see README below)
    # sudo cpupower frequency-set -g performance

    $NOTIFY "🎮 Gaming Mode ON" "Waybar, wallpaper & blur killed. GL HF."
}

disable_gaming_mode() {
    rm -f "$STATE_FILE"

    # ── Restore Hyprland effects ──────────────────────────────────────────────
    hyprctl keyword animations:enabled 1
    hyprctl keyword decoration:blur:enabled 1
    hyprctl keyword decoration:shadow:enabled 1
    hyprctl keyword decoration:inactive_opacity 0.9   # match your hyprland.conf
    hyprctl keyword decoration:active_opacity 1
    hyprctl keyword misc:vfr 1

    # ── Relaunch desktop processes ────────────────────────────────────────────
    waybar &
    awww &

    # ── CPU governor → back to balanced ──────────────────────────────────────
    # sudo cpupower frequency-set -g schedutil

    $NOTIFY "🖥️ Gaming Mode OFF" "Desktop restored."
}

# ── Toggle ────────────────────────────────────────────────────────────────────
if [[ -f "$STATE_FILE" ]]; then
    disable_gaming_mode
else
    enable_gaming_mode
fi
