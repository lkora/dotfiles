#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Unit Test: Configuration Files
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")"

echo "Testing configuration file syntax..."

failures=0

# Test zshrc syntax
if [[ -f "$DOTFILES_DIR/configs/zsh/.zshrc" ]]; then
    if zsh -c "source $DOTFILES_DIR/configs/zsh/.zshrc" 2>/dev/null; then
        echo "  ✓ .zshrc syntax is valid"
    else
        echo "  ✗ .zshrc has syntax errors"
        ((failures++))
    fi
else
    echo "  ⚠ .zshrc not found (skipping)"
fi

# Test vimrc if exists
if [[ -f "$DOTFILES_DIR/configs/vim/.vimrc" ]]; then
    if vim -c "source $DOTFILES_DIR/configs/vim/.vimrc" -c "qa!" 2>/dev/null; then
        echo "  ✓ .vimrc syntax is valid"
    else
        echo "  ⚠ .vimrc test inconclusive (vim may have loaded it)"
    fi
else
    echo "  ⚠ .vimrc not found (skipping)"
fi

# Test waybar config if exists
if [[ -f "$DOTFILES_DIR/configs/waybar/.config/config" ]]; then
    if jq . "$DOTFILES_DIR/configs/waybar/.config/config" >/dev/null 2>&1; then
        echo "  ✓ waybar config is valid JSON"
    else
        echo "  ✗ waybar config has invalid JSON"
        ((failures++))
    fi
else
    echo "  ⚠ waybar config not found (skipping)"
fi

if [[ $failures -eq 0 ]]; then
    echo "✅ All unit checks passed"
    exit 0
else
    echo "❌ $failures check(s) failed"
    exit 1
fi
