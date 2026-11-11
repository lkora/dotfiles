#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Flatpak Application Installation Script
# Purpose: Install user applications via Flatpak (sandboxed, native on Fedora)
# =============================================================================

log_info() { echo -e "  [INFO] $1"; }
log_success() { echo -e "  ✓ $1"; }

# Enable Flatpak if not already enabled
if ! systemctl is-active --quiet flatpak-system.socket; then
    log_info "Enabling Flatpak system services..."
    systemctl --user enable --now flatpak-system.socket
fi

# Install Flatpak runtime (if needed)
if ! flatpak list 2>/dev/null | grep -q "runtime/org.freedesktop.Platform"; then
    log_info "Installing Flatpak runtime..."
    flatpak install flathub org.freedesktop.Platform//54.0
fi

# Install applications
log_info "Installing Flatpak applications..."

# Web Browser
log_info "Installing Librewolf..."
flatpak install flathub org.librewolf.LibreWolf -y

# Media & Productivity
log_info "Installing VLC..."
flatpak install flathub org.videolan.VLC -y

log_info "Installing OBS Studio..."
flatpak install flathub com.obsproject.Studio -y

log_info "Installing Krita..."
flatpak install flathub org.kde.Krita -y

log_info "Installing Obsidian..."
flatpak install flathub md.obsidian.Obsidian -y

log_info "Installing Mailspring..."
flatpak install flathub com.mailspring.Mailspring -y

# Communication
log_info "Installing Telegram Desktop..."
flatpak install flathub org.telegram.desktop -y

log_info "Installing Signal Desktop..."
flatpak install flathub com.signalapp.Signal -y

# Development & Utilities
log_info "Installing VS Code (via Distrobox - see distrobox/setup.sh)..."

log_info "Installing Discord..."
flatpak install flathus com.discordapp.Discord -y

log_info "Installing Steam (via Distrobox - see distrobox/setup.sh)..."

log_success "Flatpak applications installation complete!"
