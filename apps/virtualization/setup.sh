#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Virtualization Support Setup Script
# Purpose: Install and configure VM/VirtualBox support
# =============================================================================

log_info() { echo -e "  [INFO] $1"; }
log_success() { echo -e "  ✓ $1"; }

# Install virtualization packages
log_info "Installing virtualization support..."
rpm-ostree install \
    virt-install \
    virt-manager \
    libvirt \
    libvirt-daemon-driver-qemu \
    virt-install-gui \
    virt-viewer \
    virt-manager-gui \
    qemu-guest-agent \
    guestfs-tools \
    virt-install-gui \
    spice-protocol \
    spice-vdagent

# Install VirtualBox/VMware if available via RPM Fusion or COPR
log_info "Checking for VirtualBox/VMware packages..."

# VirtualBox (requires Oracle license agreement)
if command -v vboxmanage >/dev/null 2>&1; then
    log_success "VirtualBox already installed"
else
    log_info "VirtualBox not found. Install via:"
    echo "  sudo dnf install VirtualBox VirtualBox-host-modules-fedora"
fi

# VMware (if available)
log_info "VMware packages available via Fedora repository"
log_info "Install via:"
echo "  sudo dnf install open-vm-tools open-vm-tools-desktop"

# Enable libvirt services
log_info "Enabling libvirt services..."
systemctl enable --now libvirtd

log_success "Virtualization support setup complete!"
