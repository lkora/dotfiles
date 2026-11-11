#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Distrobox Configuration Script
# Purpose: Set up Docker/Podman containers for VSCode and Steam
# =============================================================================

log_info() { echo -e "  [INFO] $1"; }
log_success() { echo -e "  ✓ $1"; }

# Create Distrobox containers
log_info "Creating Distrobox containers..."

# VSCode Container
log_info "Creating VSCode container..."
distrobox create \
    --name vscode \
    --image fedora:latest \
    --default

# Steam Container
log_info "Creating Steam container..."
distrobox create \
    --name steam \
    --image fedora:latest \
    --default

# Enter containers and install apps
log_info "Installing VSCode in vscode container..."
distrobox enter --name vscode << 'EOF'
#!/bin/bash
set -euo pipefail

# Install VSCode
sudo dnf install -y code

# Setup ZSH (optional)
# sudo dnf install -y zsh oh-my-zsh

echo "VSCode installed successfully"
EOF

log_info "Installing Steam in steam container..."
distrobox enter --name steam << 'EOF'
#!/bin/bash
set -euo pipefail

# Install Steam
sudo dnf install -y steam

echo "Steam installed successfully"
EOF

log_success "Distrobox containers created!"

# Add aliases to .zshrc (optional, can be done manually)
log_info "To use containers, run:"
echo "  distrobox enter --name vscode"
echo "  distrobox enter --name steam"
echo ""
echo "Or add aliases to ~/.zshrc:"
echo "  alias vscode='distrobox enter --name vscode --command \"/usr/bin/code \"\$@\"'"
echo "  alias steam='distrobox enter --name steam --command \"steam\"'"
