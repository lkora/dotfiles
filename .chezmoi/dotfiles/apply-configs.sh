#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Config Application Script
# Purpose: Apply all dotfiles configurations (for updates & maintenance)
# Usage: ./scripts/apply-configs.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && dirname "$(dirname "${BASH_SOURCE[0]}")")"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

log_info() { echo -e "  [INFO] $1"; }
log_success() { echo -e "  ✓ $1"; }
log_warn()  { echo -e "  ⚠ $1"; }
log_error() { echo -e "  ✗ $1"; }

# Check if running as root (for system configs) or user (for user configs)
if [[ $EUID -eq 0 ]]; then
    log_info "Running as root - will sync user configs to first user"
    FIRST_USER=$(awk -F: '$3==1 {print $1; exit}' /etc/passwd)
    if [[ -n "$FIRST_USER" ]]; then
        USER_HOME="/home/$FIRST_USER"
    else
        log_warn "Could not determine first user"
        exit 1
    fi
else
    log_info "Running as user - will sync to current user"
    USER_HOME="$HOME"
fi

# Ensure .dotfiles directory exists
mkdir -p "$USER_HOME/.dotfiles"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║              Apply Dotfiles Configuration                ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Sync core configs
log_info "Step 1: Syncing core configurations..."
# sync-user.sh uses $HOME, which is already set correctly in this subshell context

# Step 2: Apply LazyVim configuration
log_info "Step 2: Applying LazyVim configuration..."
SCRIPT_DIR_ABS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR_ABS"/../scripts/fetch-lazyvim-config.sh
"$SCRIPT_DIR_ABS"/../scripts/merge-lazyvim-config.sh

# Step 3: Validate configuration
log_info "Step 3: Validating configuration..."
"$DOTFILES_DIR"/tests/unit/check-config.sh

# Step 4: Check LazyVim specific
log_info "Step 4: Checking LazyVim installation..."
"$DOTFILES_DIR"/tests/unit/check-lazyvim.sh

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              Configuration Applied Successfully           ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  • Reload zsh: source ~/.zshrc"
echo "  • Reload LazyVim: nvim --cmd 'source ~/.config/nvim/lua/lazyvim/config/lspconfig.lua'"
echo "  • Validate: $DOTFILES_DIR/boot/validate.sh"
echo ""
