#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# LazyVim Config Merge Script
# Purpose: Merge remote defaults + local overrides + examples into final config
# Usage: ./scripts/merge-lazyvim-config.sh
# =============================================================================

NVIIM_DIR="$HOME/.config/nvim"
CONFIG_DIR="$NVIIM_DIR/lua/lazyvim/config"

log_info() { echo -e "  [INFO] $1"; }
log_success() { echo -e "  ✓ $1"; }
log_warn()  { echo -e "  ⚠ $1"; }
log_error() { echo -e "  ✗ $1"; }

# Check if nvim is installed
if ! command -v nvim >/dev/null 2>&1; then
    log_warn "nvim not found. Skipping LazyVim config merge."
    exit 0
fi

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

# Check for source files
if [[ ! -f "$CONFIG_DIR/lspconfig.lua" ]]; then
    log_error "Remote config not found at $CONFIG_DIR/lspconfig.lua"
    log_info "Run ./scripts/fetch-lazyvim-config.sh first"
    exit 1
fi

if [[ ! -f "$CONFIG_DIR/lspconfig.lua.local" ]]; then
    log_warn "Local override not found at $CONFIG_DIR/lspconfig.lua.local"
    log_info "Use lspconfig.lua.example as a template"
fi

# Merge configs
log_info "Merging LazyVim configuration..."

# Copy remote config as base
cp "$CONFIG_DIR/lspconfig.lua" "$CONFIG_DIR/lspconfig.lua.merged"

# Append local overrides if they exist
if [[ -f "$CONFIG_DIR/lspconfig.lua.local" ]]; then
    log_info "Appending local overrides..."
    cat "$CONFIG_DIR/lspconfig.lua.local" >> "$CONFIG_DIR/lspconfig.lua.merged"
else
    log_info "No local overrides found"
fi

# Validate merged config
log_info "Validating merged configuration..."
if nvim -c "source $CONFIG_DIR/lspconfig.lua.merged" -c "qa!" 2>/dev/null; then
    log_success "Merged configuration is valid"
    mv "$CONFIG_DIR/lspconfig.lua.merged" "$CONFIG_DIR/lspconfig.lua"
    log_success "Config merged successfully"
else
    log_error "Merged configuration has errors"
    log_info "Restoring original config..."
    mv "$CONFIG_DIR/lspconfig.lua" "$CONFIG_DIR/lspconfig.lua.backup"
    exit 1
fi

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              LazyVim Configuration Merged                ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "Your configuration is now ready at:"
echo "  $CONFIG_DIR/lspconfig.lua"
echo ""
echo "To apply changes, run:"
echo "  nvim --cmd 'source $CONFIG_DIR/lspconfig.lua'"
echo ""
