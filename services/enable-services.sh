#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Service Enablement Script
# Purpose: Enable dotfiles sync and related services
# =============================================================================

log_info() { echo -e "  [INFO] $1"; }
log_success() { echo -e "  ✓ $1"; }

# Create user symlink for dotfiles
log_info "Creating dotfiles symlink..."
if [[ ! -L "$HOME"/.dotfiles ]]; then
    ln -s "$HOME"/.dotfiles "$HOME"/.dotfiles 2>/dev/null || true
fi

# Load dotfiles into user session (if exists)
if [[ -f "$HOME"/.zshrc ]]; then
    log_info "Loading zsh config for current session..."
    source "$HOME"/.zshrc 2>/dev/null || log_warn "Failed to load .zshrc"
fi

# Enable dotfiles sync service
log_info "Enabling dotfiles sync service..."
systemctl daemon-reload
systemctl enable --now dotfiles-sync || log_warn "Could not enable dotfiles-sync service (may already be enabled)"

log_success "Services enabled!"
