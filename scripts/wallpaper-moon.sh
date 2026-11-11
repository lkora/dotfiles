#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Wallpaper Setup Script
# Purpose: Set Unsplash moon photo as default background
# =============================================================================

log_info() { echo -e "  [INFO] $1"; }
log_success() { echo -e "  ✓ $1"; }

WALLPAPER_URL="https://images.unsplash.com/photo-1506744038156-89fb72669d69?q=80&w=1920&auto=format&fit=crop"
WALLPAPER_DIR="$HOME/.wallpapers"
WALLPAPER_FILE="$WALLPAPER_DIR/moon-unsplash.jpg"

log_info "Downloading moon wallpaper..."
mkdir -p "$WALLPAPER_DIR"
curl -fsSL -o "$WALLPAPER_FILE" "$WALLPAPER_URL"

if [[ -f "$WALLPAPER_FILE" ]]; then
    log_success "Wallpaper downloaded to $WALLPAPER_FILE"
    log_info "To set as background, run:"
    echo "  girder --set-wallpaper $WALLPAPER_FILE"
    echo "  OR:"
    echo "  gsettings set org.gnome.desktop.background picture-uri 'file:///path/to/wallpaper.jpg'"
else
    log_warn "Failed to download wallpaper"
fi
