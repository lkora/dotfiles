#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && dirname "$(dirname "${BASH_SOURCE[0]}")")"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║              Dotfiles Validation Check                   ║"
echo "╚══════════════════════════════════════════════════════════╝"

PASS=0
FAIL=0
WARN=0

pass() {
    local msg="${1:-no msg}"
    ((PASS++))
    echo "  ✓ $msg"
}

fail() {
    local msg="${1:-no msg}"
    ((FAIL++))
    echo "  ✗ $msg"
}

warn() {
    local msg="${1:-no msg}"
    ((WARN++))
    echo "  ⚠ $msg"
}

info() {
    echo "  [INFO] $1"
}

info "Checking directory structure..."
[[ -d "$DOTFILES_DIR" ]] && pass "Dotfiles root directory exists" || fail "Dotfiles root directory exists"
[[ -d "$DOTFILES_DIR/meta" ]] && pass "Meta directory exists" || fail "Meta directory exists"
[[ -d "$DOTFILES_DIR/configs" ]] && pass "Configs directory exists" || fail "Configs directory exists"
[[ -d "$DOTFILES_DIR/scripts" ]] && pass "Scripts directory exists" || fail "Scripts directory exists"
[[ -d "$DOTFILES_DIR/apps" ]] && pass "Apps directory exists" || fail "Apps directory exists"
[[ -d "$DOTFILES_DIR/services" ]] && pass "Services directory exists" || fail "Services directory exists"

info "Checking critical files..."
[[ -f "$DOTFILES_DIR/boot/bootstrap.sh" ]] && pass "Bootstrap script exists" || fail "Bootstrap script exists"
[[ -x "$DOTFILES_DIR/boot/bootstrap.sh" ]] && pass "Bootstrap script is executable" || fail "Bootstrap script is executable"
[[ -f "$DOTFILES_DIR/services/dotfiles-sync.service" ]] && pass "Sync service template exists" || fail "Sync service template exists"

info "Checking user deployment..."
[[ -f "$HOME/.zshrc" ]] && pass ".zshrc deployed" || warn ".zshrc not deployed (optional)"
[[ -d "$HOME/.config/nvim" ]] && pass "Nvim config deployed (if applicable)" || warn "Nvim config not deployed (optional)"
[[ -d "$HOME/.dotfiles" ]] && pass ".dotfiles directory exists" || warn ".dotfiles not deployed (optional)"

info "Checking system services..."
systemctl is-active dotfiles-sync 2>/dev/null && pass "dotfiles-sync service is active" || warn "dotfiles-sync not active (optional)"

info "Checking version metadata..."
if [[ -f "$DOTFILES_DIR/meta/version.json" ]]; then
    VERSION=$(grep -o '"version": *"[^"]*"' "$DOTFILES_DIR/meta/version.json" | grep -o '[0-9.]*' | head -1)
    echo "  Found version: $VERSION"
    pass "Version metadata file is valid"
else
    warn "Version metadata file not found"
fi

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                    Validation Summary                     ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo "  Passed:  $PASS"
echo "  Failed:  $FAIL"
echo "  Warnings: $WARN"

if [[ $FAIL -gt 0 ]]; then
    echo ""
    echo "❌ Validation failed. Please fix errors."
    exit 1
elif [[ $WARN -gt 0 ]]; then
    echo ""
    echo "⚠️  Validation passed with warnings."
    exit 0
else
    echo ""
    echo "✅ All checks passed."
    exit 0
fi
