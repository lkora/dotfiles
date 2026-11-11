#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Catppuccin Mocha Theme Configuration
# Purpose: Set up system-wide Catppuccin Mocha color scheme
# =============================================================================

log_info() { echo -e "  [INFO] $1"; }

# Color palette (Mocha variant)
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Set terminal colors via xterm-256color
log_info "Configuring Catppuccin Mocha terminal colors..."

# You can add this to ~/.zshrc or ~/.bashrc for persistence
cat >> ~/.config/color-schemes/catppuccin-mocha 2>/dev/null << 'EOF'
#!/usr/bin/env bash
# Catppuccin Mocha Terminal Colors
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Base colors
COLOR_Bg="#1e1e2e"
COLOR_Fg="#cdd6f4"

# Red palette
COLOR_Error="#f38ba8"
COLOR_Red="#f38ba8"

# Orange palette
COLOR_Orange="#fab387"

# Yellow palette
COLOR_Yellow="#f9e2af"

# Green palette
COLOR_Green="#a6e3a1"

# Blue palette
COLOR_Blue="#89b4fa"

# Purple palette
COLOR_Purple="#b4befe"

# Pink palette
COLOR_Pink="#f5c2e7"

# Gray palette
COLOR_Slate="#94e2d5"

# Custom cursor colors for apps that support it
export XTERM_COLORS="$COLOR_Bg $COLOR_Fg $COLOR_Error $COLOR_Orange $COLOR_Yellow $COLOR_Green $COLOR_Blue $COLOR_Purple $COLOR_Pink $COLOR_Slate"
EOF

log_success "Catppuccin Mocha theme configured!"
