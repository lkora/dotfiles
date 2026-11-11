#!/usr/bin/env zsh
# =============================================================================
# ZSH Configuration - Oh My ZSH with Catppuccin Mocha Theme
# =============================================================================

# Load Oh My ZSH
if [[ -f /usr/share/oh-my-zsh.sh ]]; then
    source /usr/share/oh-my-zsh.sh
else
    echo "⚠️  Oh My ZSH not found. Install via: zsh install-oh-my-zsh"
fi

# Theme: Catppuccin Mocha
ZSH_THEME="catppuccin-mocha"

# Plugins
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-autocomplete
)

# Enable plugins immediately
plugins+=(
    zsh-autosuggestions
    zsh-autocomplete
)

# =============================================================================
# Environment & Path Configuration
# =============================================================================

# Add dotfiles bin to PATH
export PATH="$HOME/.dotfiles/bin:$PATH"

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# =============================================================================
# Aliases
# =============================================================================

# Git aliases
alias gs='git status'
alias ga='git add'
alias gca='git commit -a'
alias gp='git push'
alias gpl='git pull'
alias gcm='git commit -m'
alias gcl='git clone'
alias gd='git diff'
alias glg='git log --oneline --graph --decorate --all'

# System aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias sed='sed --color=always'
alias less='less -R'

# Development aliases
alias tree='eza --tree --icons=always --group-directories-first'
alias rg='rg --hidden --vimgrep'
alias fd='fd --type file --hidden'

# =============================================================================
# Prompt & Colors
# =============================================================================

# Set terminal colors (Catppuccin Mocha palette)
export CLICOLOR=1
export CLICOLOR_FORCE=1

# =============================================================================
# Utility Functions
# =============================================================================

# Better ls
ls() {
    if command -v eza >/dev/null 2>&1; then
        eza --icons=always --group-directories-first "$@"
    else
        ls --color=always "$@"
    fi
}

# Quick directory navigation
cd() {
    if [[ "$1" == .. || "$1" == ... || "$1" == .... ]]; then
        cd "$1"
        return
    fi
    builtin cd "$1"
}

# =============================================================================
# LazyVim Integration (if installed)
# =============================================================================

if [[ -d "$HOME/.local/state/nvim/lazy" ]] && command -v nvim >/dev/null 2>&1; then
    # LazyVim completion for zsh
    source "$HOME/.local/state/nvim/lazy/plugins/completions/zsh.lua" 2>/dev/null || true
fi

# =============================================================================
# FZF Configuration
# =============================================================================

if command -v fzf >/dev/null 2>&1; then
    [[ -n "$FZF_DEFAULT_OPTS" ]] || \
        export FZF_DEFAULT_OPTS="-i --height 40% --border none --color=bg+:#1e1e2e --color=fg:#cdd6f4"
fi

# =============================================================================
# Quick Links (if installed)
# =============================================================================

if command -v qlink >/dev/null 2>&1; then
    source <(qlink)
fi

# =============================================================================
# Dotfiles Scripts Path
# =============================================================================

# Add dotfiles bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Dotfiles sync utility
# Usage: ~/bin/dotfiles/sync [status|apply|revert|diff|pull|push]
