#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles User Sync Script
# Purpose: Sync dotfiles to user home directory
# Safe to run multiple times, idempotent
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && dirname "$(dirname "${BASH_SOURCE[0]}")")"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║              Dotfiles User Sync                          ║"
echo "╚══════════════════════════════════════════════════════════╝"

# Create backup before sync
BACKUP_DIR="$HOME/.dotfiles/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
if [[ -d "$HOME"/.config ]]; then
    cp -r "$HOME"/.config/* "$BACKUP_DIR"/ 2>/dev/null || true
fi
if [[ -d "$HOME"/.local/share ]]; then
    cp -r "$HOME"/.local/share/* "$BACKUP_DIR"/ 2>/dev/null || true
fi

log_info "Syncing configs from $DOTFILES_DIR"

# Zsh configuration
echo "  → .zshrc"
rsync -a "$DOTFILES_DIR"/configs/zsh/.zshrc "$HOME"/

# Vim configuration (if exists)
if [[ -d "$DOTFILES_DIR"/configs/vim ]]; then
    echo "  → .vimrc"
    rsync -a "$DOTFILES_DIR"/configs/vim/.vimrc "$HOME"/
fi

# Nvim configuration (if exists)
if [[ -d "$DOTFILES_DIR"/configs/nvim ]]; then
    echo "  → nvim config"
    rsync -a "$DOTFILES_DIR"/configs/nvim/ "$HOME"/.config/nvim/
fi

# Waybar configuration (if exists)
if [[ -d "$DOTFILES_DIR"/configs/waybar ]]; then
    echo "  → waybar config"
    rsync -a "$DOTFILES_DIR"/configs/waybar/.config "$HOME"/.config/
fi

# Sway configuration (if exists)
if [[ -d "$DOTFILES_DIR"/configs/sway ]]; then
    echo "  → sway config"
    rsync -a "$DOTFILES_DIR"/configs/sway/swayconfig "$HOME"/.config/sway/
fi

echo "  → dotfiles sync complete"
echo "Backup stored at: $BACKUP_DIR"
