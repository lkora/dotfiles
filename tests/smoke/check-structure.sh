#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Smoke Test: Directory Structure
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && dirname "$(dirname "${BASH_SOURCE[0]}")")"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "Checking dotfiles directory structure..."

failures=0

# Required directories
for dir in meta boot configs apps scripts services; do
    if [[ -d "$DOTFILES_DIR/$dir" ]]; then
        echo "  ✓ $dir/"
    else
        echo "  ✗ $dir/ (missing)"
        ((failures++))
    fi
done

# Required files
for file in boot/bootstrap.sh services/dotfiles-sync.service; do
    if [[ -f "$DOTFILES_DIR/$file" ]]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file (missing)"
        ((failures++))
    fi
done

if [[ $failures -eq 0 ]]; then
    echo "✅ All smoke checks passed"
    exit 0
else
    echo "❌ $failures check(s) failed"
    exit 1
fi
