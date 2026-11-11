#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Integration Test: Dotfiles Sync
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")"

echo "Testing dotfiles sync functionality..."

failures=0

# Test 1: rsync availability
if command -v rsync >/dev/null 2>&1; then
    echo "  ✓ rsync is available"
else
    echo "  ✗ rsync is not available"
    ((failures++))
fi

# Test 2: Test sync-user.sh execution
if [[ -x "$DOTFILES_DIR/boot/sync-user.sh" ]]; then
    echo "  ✓ sync-user.sh is executable"
    
    # Create a test file
    mkdir -p "$HOME"/.dotfiles/test
    echo "test content" > "$HOME"/.dotfiles/test/test.txt
    
    # Run sync
    bash "$DOTFILES_DIR/boot/sync-user.sh" >/dev/null 2>&1
    
    if [[ -f "$HOME"/.config/zsh/.zshrc ]]; then
        echo "  ✓ zsh config synced to user home"
    else
        echo "  ✗ zsh config not synced"
        ((failures++))
    fi
    
    # Cleanup test file
    rm -rf "$HOME"/.dotfiles/test
else
    echo "  ✗ sync-user.sh is not executable"
    ((failures++))
fi

if [[ $failures -eq 0 ]]; then
    echo "✅ All integration checks passed"
    exit 0
else
    echo "❌ $failures check(s) failed"
    exit 1
fi
