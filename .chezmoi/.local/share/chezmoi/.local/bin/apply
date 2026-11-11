#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Config Application Script (Chezmoi)
# Purpose: Apply all dotfiles configurations
# Usage: ~/bin/dotfiles/sync apply
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && dirname "${BASH_SOURCE[0]}")"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

log_info() { echo -e "  [INFO] $1"; }
log_success() { echo -e "  ✓ $1"; }
log_warn()  { echo -e "  ⚠ $1"; }
log_error() { echo -e "  ✗ $1"; }

# Check if chezmoi is installed
if ! command -v chezmoi >/dev/null 2>&1; then
    log_error "chezmoi not found"
    log_info "Install via: cargo install chezmoi"
    exit 1
fi

echo "╔══════════════════════════════════════════════════════════╗"
echo "║              Apply Dotfiles Configuration                ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Apply via chezmoi
log_info "Step 1: Applying configurations via chezmoi..."
if ! chezmoi apply --auto; then
    log_error "Failed to apply configurations"
    exit 1
fi

# Step 2: Apply LazyVim configuration
log_info "Step 2: Applying LazyVim configuration..."
"$DOTFILES_DIR"/scripts/fetch-lazyvim-config.sh
"$DOTFILES_DIR"/scripts/merge-lazyvim-config.sh

# Step 3: Validate configuration
log_info "Step 3: Validating configuration..."
if ! "$DOTFILES_DIR"/tests/unit/check-config.sh; then
    log_warn "Some validation checks failed"
fi

# Step 4: Check LazyVim specific
log_info "Step 4: Checking LazyVim installation..."
if ! "$DOTFILES_DIR"/tests/unit/check-lazyvim.sh; then
    log_warn "Some LazyVim checks failed"
fi

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              Configuration Applied Successfully           ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  • Reload zsh: source ~/.zshrc"
echo "  • Reload LazyVim: nvim --cmd 'source ~/.config/nvim/lua/lazyvim/config/lspconfig.lua'"
echo "  • Validate: ~/bin/dotfiles/sync status"
echo ""
