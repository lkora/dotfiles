#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Kangawa Theme Configuration
# Purpose: Set up system-wide Kangawa color scheme
# =============================================================================

log_info() { echo -e "  [INFO] $1"; }

# Color palette (Kangawa variant)
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Set terminal colors via xterm-256color
log_info "Configuring Kangawa terminal colors..."

# You can add this to ~/.zshrc or ~/.bashrc for persistence
cat >> ~/.config/color-schemes/kangawa 2>/dev/null << 'EOF'
#!/usr/bin/env bash
# Kangawa Terminal Colors
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Base colors
COLOR_Bg="#1a1a1a"
COLOR_Fg="#e0e0e0"

# Red palette
COLOR_Error="#ff5f56"
COLOR_Red="#ff5f56"

# Orange palette
COLOR_Orange="#ffbd5e"

# Yellow palette
COLOR_Yellow="#ffec84"

# Green palette
COLOR_Green="#50fa7b"

# Blue palette
COLOR_Blue="#5fb3e7"

# Purple palette
COLOR_Purple="#c678dd"

# Pink palette
COLOR_Pink="#ff79c6"

# Gray palette
COLOR_Slate="#8be9fd"

# Custom cursor colors
export XTERM_COLORS="$COLOR_Bg $COLOR_Fg $COLOR_Error $COLOR_Orange $COLOR_Yellow $COLOR_Green $COLOR_Blue $COLOR_Purple $COLOR_Pink $COLOR_Slate"
EOF

log_success "Kangawa theme configured!"
