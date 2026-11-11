#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Font Configuration Script
# Purpose: Set up system-wide Nerdfont Mono and fallback fonts
# =============================================================================

log_info() { echo -e "  [INFO] $1"; }
log_success() { echo -e "  ✓ $1"; }

FONT_DIR="/usr/share/fonts/jetbrains-mono-nerd"
FONT_ZIP="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"

# Install JetBrainsMono Nerd Font if not present
if [[ ! -d "$FONT_DIR" ]] || [[ -z "$(ls -A "$FONT_DIR" 2>/dev/null)" ]]; then
    log_info "Installing JetBrainsMono Nerd Font..."
    mkdir -p "$FONT_DIR"
    curl -fsSL -o /tmp/font.zip "$FONT_ZIP"
    tar -xf /tmp/font.zip -C "$FONT_DIR"
    rm -f /tmp/font.zip
    
    # Configure fontconfig for Nerdfont Mono
    echo "  → Configuring font fallback chain..."
    echo "  → JetBrainsMono Nerd Font → Nerd Font Mono → Fira Code → Monospace"
    
    log_success "Font installation complete!"
else
    log_info "JetBrainsMono Nerd Font already installed"
fi

# Set system font via fontconfig (optional, for non-root users)
log_info "Checking fontconfig configuration..."
if command -v fc-cache &>/dev/null; then
    fc-cache -f "$FONT_DIR" 2>/dev/null || log_warn "Could not update font cache"
fi

log_success "Font setup complete!"
