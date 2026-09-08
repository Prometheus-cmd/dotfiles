#!/usr/bin/env bash
# backup.sh — snapshot your current Hyprland/Arch config into this repo
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Edit these to match what you actually use ---
# Folders under ~/.config to track
CONFIG_DIRS=(
  hypr
  waybar
  wofi
  kitty
  alacritty
  dunst
  fish
)

# Individual files that live directly in $HOME
HOME_FILES=(
  .bashrc
  .zshrc
  .gitconfig
)

# Standalone scripts outside ~/.config (paths relative to $HOME) —
# these are the ones hyprland.conf actually calls by path
SCRIPT_FILES=(
  .local/bin/wallpaper
  .local/bin/restore-wallpaper
  .local/bin/theme-switcher
)
# ---------------------------------------------------

mkdir -p "$REPO_DIR/config" "$REPO_DIR/home" "$REPO_DIR/scripts"

echo "==> Copying ~/.config dirs"
for d in "${CONFIG_DIRS[@]}"; do
  if [ -d "$HOME/.config/$d" ]; then
    rsync -a --delete "$HOME/.config/$d/" "$REPO_DIR/config/$d/"
    echo "  copied: $d"
  else
    echo "  skipped (not found): $d"
  fi
done

echo "==> Copying home dotfiles"
for f in "${HOME_FILES[@]}"; do
  if [ -f "$HOME/$f" ]; then
    cp "$HOME/$f" "$REPO_DIR/home/$f"
    echo "  copied: $f"
  else
    echo "  skipped (not found): $f"
  fi
done

echo "==> Copying standalone scripts"
for f in "${SCRIPT_FILES[@]}"; do
  if [ -f "$HOME/$f" ]; then
    mkdir -p "$REPO_DIR/scripts/$(dirname "$f")"
    cp "$HOME/$f" "$REPO_DIR/scripts/$f"
    echo "  copied: $f"
  else
    echo "  skipped (not found): $f"
  fi
done

echo "==> Exporting package lists"
pacman -Qqe > "$REPO_DIR/pkglist.txt"
if command -v yay >/dev/null; then
  yay -Qqem > "$REPO_DIR/aur-pkglist.txt"
elif command -v paru >/dev/null; then
  paru -Qqem > "$REPO_DIR/aur-pkglist.txt"
else
  echo "  (no AUR helper found, leaving aur-pkglist.txt empty)"
  : > "$REPO_DIR/aur-pkglist.txt"
fi

echo "==> Done. Review with 'git status', then commit & push."
