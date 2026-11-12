#!/usr/bin/env bash
set -euo pipefail
[[ -e /.dockerenv || -e /run/.containerenv ]] || {
    echo "Run this check inside the Fedora Sway container." >&2
    exit 1
}
source_config="${1:-/dotfiles/home/dot_config}"
useradd --create-home --uid 29000 dotfiles-check
mkdir -p /home/dotfiles-check/.config
cp -r "$source_config/sway" /home/dotfiles-check/.config/
chown -R dotfiles-check:dotfiles-check /home/dotfiles-check/.config
install -d -m 700 -o dotfiles-check -g dotfiles-check /home/dotfiles-check/runtime
runuser -u dotfiles-check -- env \
    XDG_RUNTIME_DIR=/home/dotfiles-check/runtime WLR_BACKENDS=headless WLR_RENDERER=pixman \
    sway --validate --config /home/dotfiles-check/.config/sway/config
foot --check-config --config="$source_config/foot/foot.ini"
