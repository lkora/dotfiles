#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# LazyVim Remote Config Fetcher
# Purpose: Fetch LazyVim's default config from GitHub (fallback to local defaults)
# Design: Modular, robust to URL changes, allows local overrides
# =============================================================================

NVIIM_DIR="${HOME:-$HOME}/.config/nvim"
CONFIG_DIR="$NVIIM_DIR/lua/lazyvim/config"
REMOTE_REPO="LazyVim/LazyVim"
REMOTE_BRANCH="main"

log_info() { echo -e "  [INFO] $1"; }
log_warn()  { echo -e "  [WARN] $1"; }
log_success() { echo -e "  ✓ $1"; }

# Create sensible local defaults if remote fails
create_local_defaults() {
    mkdir -p "$CONFIG_DIR"
    
    # Minimal lspconfig.lua with good defaults
    cat > "$CONFIG_DIR/lspconfig.lua" << 'EOF'
-- Minimal LazyVim lspconfig defaults (fallback)
LspConfig.setup {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  on_attach = function(client, bufnr)
    -- Diagnostics
    vim.diagnostic.config({
      virtual_text = { format = function(diagnostic)
        local sign = string.sub(diagnostic.sign, 1, 1)
        local msg = string.sub(diagnostic.message, 1, 50)
        return (sign .. " " .. msg)
      end,
      update_in_insert = true,
      severity_sort = true,
    })
    
    -- Keymaps
    vim.keymap.set('n', '<leader>rn', "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol" })
    vim.keymap.set('n', '<leader>ca', "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code actions" })
    vim.keymap.set('n', 'gd', "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })
    vim.keymap.set('n', 'K', "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover documentation" })
    
    -- Treesitter context
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.document_highlight then
          vim.api.nvim_clear_autocmds({ buffer = event.buf, callback = function()
            vim.api.nvim_create_autocmd("BufEnter", {
              buffer = event.buf,
              callback = function()
                vim.lsp.buf.document_highlight()
              end,
            })
          end})
        end
      end,
    })
  end,
}
EOF
    
    log_success "Local defaults created at $CONFIG_DIR/lspconfig.lua"
}

# Fetch config from remote (tries multiple known locations)
fetch_remote_config() {
    local remote_url=""
    
    # Try official LazyVim main branch
    remote_url="https://raw.githubusercontent.com/${REMOTE_REPO}/${REMOTE_BRANCH}/lua/lazyvim/plugins/core/lspconfig.lua"
    
    # Check if remote exists before fetching
    HTTP_CODE=$(curl -sL -o /dev/null -w "%{http_code}" --max-time 5 "$remote_url" 2>/dev/null || echo "0")
    
    if [[ "$HTTP_CODE" == "200" ]]; then
        curl -sL --max-time 10 --retry 3 --retry-delay 2 --retry-max-time 60 "$remote_url" > "$CONFIG_DIR/lspconfig.lua" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            log_success "Fetched lspconfig.lua from LazyVim remote"
            return 0
        fi
    fi
    
    # Fallback: use minimal sensible defaults locally
    log_warn "Remote fetch failed (HTTP $HTTP_CODE), using local defaults"
    log_info "Creating local LazyVim defaults..."
    create_local_defaults
    return 1
}

# Check for local overrides
check_local_overrides() {
    if [[ -f "$NVIIM_DIR/lua/lazyvim/config/lspconfig.lua.local" ]]; then
        log_info "Found local override file, merging..."
        # Merge local overrides (append after defaults)
        cat "$NVIIM_DIR/lua/lazyvim/config/lspconfig.lua.local" >> "$CONFIG_DIR/lspconfig.lua"
        log_success "Local overrides merged"
    fi
}

# Main execution
main() {
    mkdir -p "$CONFIG_DIR"
    fetch_remote_config || true
    check_local_overrides || true
    log_info "LazyVim config ready at $CONFIG_DIR/lspconfig.lua"
    return 0
}

main "$@"
