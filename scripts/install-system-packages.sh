#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# System Package Installation Script
# Purpose: Install core system-wide packages (rpm-ostree)
# Only for immutable layer - do not use for user apps
# =============================================================================

log_info() { echo -e "  [INFO] $1"; }
log_success() { echo -e "  ✓ $1"; }

# Import RPM Fusion GPG keys
log_info "Importing RPM Fusion GPG keys..."
curl -fsSL -o /tmp/RPM-GPG-KEY-rpmfusion-free \
    "https://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-free-fedora-2020"
curl -fsSL -o /tmp/RPM-GPG-KEY-rpmfusion-nonfree \
    "https://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-nonfree-fedora-2020"
rpm --import /tmp/RPM-GPG-KEY-rpmfusion-free /tmp/RPM-GPG-KEY-rpmfusion-nonfree
rm -f /tmp/RPM-GPG-KEY-rpmfusion-*

# Enable RPM Fusion repositories
log_info "Enabling RPM Fusion repositories..."
rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install core system tools
log_info "Installing core system packages..."
rpm-ostree install \
    # Shell & Terminal
    zsh \
    # Productivity & Development
    git \
    curl \
    wget \
    jq \
    tree \
    fd-find \
    ripgrep \
    eza \
    bat \
    fzf \
    # Monitoring & Utilities
    btop \
    htop \
    fastfetch \
    # Image & Video
    imagemagick \
    # System Management
    podman \
    docker-cli \
    # Hardware & Media
    libva-utils \
    intel-media-driver \
    libvdpau-va-gl \
    vdpauinfo

# Enable services
log_info "Enabling system services..."
systemctl enable podman.socket --now
systemctl enable syncthing.service --now

# Cleanup
log_info "Cleaning up..."
rpm-ostree cleanup

log_success "System packages installation complete!"
