#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# LazyVim Configuration Validation Script
# Purpose: Validate LazyVim setup, config fetch, and overrides
# =============================================================================

NVIIM_DIR="$HOME/.config/nvim"
CONFIG_DIR="$NVIIM_DIR/lua/lazyvim/config"
TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && dirname "$(dirname "${BASH_SOURCE[0]}")")"

log_info() { echo -e "  [INFO] $1"; }
log_success() { echo -e "  ✓ $1"; }
log_warn()  { echo -e "  ⚠ $1"; }
log_error() { echo -e "  ✗ $1"; }

failures=0

check() {
    if [[ "$1" -eq 0 ]]; then
        log_success "$2"
    else
        log_error "$2"
        ((failures++))
    fi
}

# Test 1: Check LazyVim is installed
log_info "Checking LazyVim installation..."
if [[ -d "$NVIIM_DIR/lua/lazyvim" ]]; then
    check $? "LazyVim directory exists"
else
    log_warn "LazyVim not installed (skipping LazyVim tests)"
    return 0
fi

# Test 2: Check config directory structure
log_info "Checking config directory structure..."
[[ -f "$CONFIG_DIR/lspconfig.lua" ]] && check $? "lspconfig.lua exists" || check 1 "lspconfig.lua exists"
[[ -f "$NVIIM_DIR/lua/lazyvim/config/init.lua" ]] && check $? "init.lua exists" || check 0 "init.lua exists (optional)"

# Test 3: Validate lspconfig.lua syntax
log_info "Validating lspconfig.lua syntax..."
if command -v lua >/dev/null 2>&1; then
    lua -e "dofile('$CONFIG_DIR/lspconfig.lua')" 2>/dev/null && check $? "lspconfig.lua is valid Lua" || check 1 "lspconfig.lua is valid Lua"
else
    log_warn "Lua not available, skipping syntax check"
fi

# Test 4: Check for remote config source
log_info "Checking remote config source..."
if curl -sL --max-time 5 "https://api.github.com/repos/LazyVim/LazyVim" >/dev/null 2>&1; then
    log_success "Can reach LazyVim GitHub API"
else
    log_warn "Cannot reach LazyVim GitHub API (network issue)"
fi

# Test 5: Check for local overrides
log_info "Checking local overrides..."
if [[ -f "$NVIIM_DIR/lua/lazyvim/config/lspconfig.lua.local" ]]; then
    log_success "Local override file exists"
    
    # Validate override syntax
    lua -e "dofile('$NVIIM_DIR/lua/lazyvim/config/lspconfig.lua.local')" 2>/dev/null && \
        log_success "Local override is valid Lua" || \
        log_error "Local override has syntax errors"
else
    log_info "No local override file found (using defaults)"
fi

# Test 6: Check config is executable/accessible
log_info "Checking config accessibility..."
if [[ -r "$CONFIG_DIR/lspconfig.lua" ]]; then
    log_success "lspconfig.lua is readable"
else
    log_error "lspconfig.lua is not readable"
    ((failures++))
fi

# Test 7: Check config size (avoid empty file)
log_info "Checking config size..."
SIZE=$(wc -c < "$CONFIG_DIR/lspconfig.lua")
if [[ $SIZE -gt 100 ]]; then
    log_success "Config file has content ($SIZE bytes)"
else
    log_warn "Config file is too small ($SIZE bytes) - may be empty"
fi

# Summary
echo ""
if [[ $failures -eq 0 ]]; then
    log_success "✅ All LazyVim checks passed"
    exit 0
else
    log_error "❌ $failures check(s) failed"
    exit 1
fi
