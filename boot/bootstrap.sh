#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles Bootstrap Script (Chezmoi)
# Purpose: One-shot bootstrap for fresh system installation using chezmoi
# Usage: sudo chezmoi init git@github.com:lkora/dotfiles.git
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║         Dotfiles Bootstrap - Fresh System Setup            ║"
echo "╚════════════════════════════════════════════════════════════╝"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

error_exit() {
    log_error "$1"
    exit 1
}

# Check root
if [[ $EUID -ne 0 ]]; then
    error_exit "This script must be run with chezmoi init (sudo chezmoi init <repo>)"
fi

log_info "Initializing chezmoi from $DOTFILES_DIR..."
if ! command -v chezmoi >/dev/null 2>&1; then
    log_error "chezmoi not found. Install via: cargo install chezmoi"
    exit 1
fi

# Initialize chezmoi (this will clone the repo and deploy)
if ! chezmoi init "$DOTFILES_DIR" >/dev/null 2>&1; then
    log_error "Failed to initialize chezmoi. Check your git credentials."
    exit 1
fi

log_success "Chezmoi initialized!"

log_info "Applying dotfiles..."
if ! chezmoi apply >/dev/null 2>&1; then
    log_error "Failed to apply dotfiles. Check permissions and repo structure."
    exit 1
fi

log_success "Dotfiles applied!"

log_info "Installing system packages..."
"$DOTFILES_DIR"/scripts/install-system-packages.sh

log_info "Setting up fonts and themes..."
"$DOTFILES_DIR"/scripts/font-setup.sh
"$DOTFILES_DIR"/scripts/wallpaper-moon.sh

log_info "Configuring virtualization support..."
"$DOTFILES_DIR"/apps/virtualization/setup.sh

log_info "Enabling services..."
"$DOTFILES_DIR"/services/enable-services.sh

log_success "Bootstrap complete!"
log_info "Next steps:"
echo "  1. Run: sudo systemctl daemon-reload && systemctl restart dotfiles-sync"
echo "  2. Reboot: sudo reboot"
echo "  3. Verify: ~/bin/dotfiles/sync --status"
