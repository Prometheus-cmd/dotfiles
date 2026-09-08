#!/usr/bin/env bash
# install.sh — restore this config onto a fresh Arch + Hyprland install
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

echo "==> Installing official packages"
sudo pacman -Syu --needed - < "$REPO_DIR/pkglist.txt"

if [ -s "$REPO_DIR/aur-pkglist.txt" ]; then
  if ! command -v yay >/dev/null && ! command -v paru >/dev/null; then
    echo "==> No AUR helper found, installing yay first"
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
  fi
  AUR_HELPER=$(command -v yay || command -v paru)
  echo "==> Installing AUR packages"
  "$AUR_HELPER" -S --needed - < "$REPO_DIR/aur-pkglist.txt"
fi

echo "==> Enabling system services"
SERVICES=(
  bluetooth
  NetworkManager
)
for svc in "${SERVICES[@]}"; do
  sudo systemctl enable --now "$svc" 2>/dev/null && echo "  enabled: $svc" \
    || echo "  couldn't enable $svc (check it's installed)"
done

link_item() {
  local src="$1" dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR/$(dirname "${dest#$HOME/}")"
    mv "$dest" "$BACKUP_DIR/${dest#$HOME/}"
    echo "  backed up existing: $dest"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  echo "  linked: $dest"
}

echo "==> Linking ~/.config dirs"
if [ -d "$REPO_DIR/config" ]; then
  for d in "$REPO_DIR"/config/*/; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    link_item "$d" "$HOME/.config/$name"
  done
fi

echo "==> Linking home dotfiles"
if [ -d "$REPO_DIR/home" ]; then
  for f in "$REPO_DIR"/home/*; do
    [ -e "$f" ] || continue
    name="$(basename "$f")"
    link_item "$f" "$HOME/$name"
  done
fi

echo "==> Linking standalone scripts"
if [ -d "$REPO_DIR/scripts" ]; then
  while IFS= read -r -d '' f; do
    rel="${f#"$REPO_DIR"/scripts/}"
    link_item "$f" "$HOME/$rel"
  done < <(find "$REPO_DIR/scripts" -type f -print0)
fi

echo "==> Done. Anything replaced was moved to $BACKUP_DIR"
echo "==> Log out and start Hyprland to see your restored config."
