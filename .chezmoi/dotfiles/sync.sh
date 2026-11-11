#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles Sync Utility
# Purpose: Clean CLI for chezmoi operations
# Usage: ~/bin/dotfiles/sync [command] [args]
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && dirname "${BASH_SOURCE[0]}")"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
HOME_DIR="$HOME"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

# Check if chezmoi is installed
check_cheimoi() {
    if ! command -v chezmoi >/dev/null 2>&1; then
        log_error "chezmoi not found"
        log_info "Install via: cargo install chezmoi"
        return 1
    fi
    return 0
}

# Main command handler
main() {
    local cmd="${1:-status}"
    shift || true

    case "$cmd" in
        status)
            check_cheimoi || return 1
            chezmoi status --format=json 2>/dev/null || log_warn "No chezmoi repo found"
            ;;
        apply)
            check_cheimoi || return 1
            local dry_run="${1:--no}"
            chezmoi apply --auto "${2:-}"
            ;;
        revert)
            check_cheimoi || return 1
            chezmoi revert "${2:-all}"
            ;;
        diff)
            check_cheimoi || return 1
            chezmoi diff
            ;;
        pull)
            check_cheimoi || return 1
            chezmoi pull
            ;;
        push)
            check_cheimoi || return 1
            chezmoi push
            ;;
        *)
            log_error "Unknown command: $cmd"
            echo "Usage: ~/bin/dotfiles/sync [status|apply|revert|diff|pull|push]"
            exit 1
            ;;
    esac
}

main "$@"
