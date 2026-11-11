-- =============================================================================
-- LazyVim Configuration Initialization
-- Purpose: Bootstrap LazyVim with remote defaults + local overrides
-- Design: Modular, validates on boot, allows seamless overrides
-- =============================================================================

local config_path = vim.fn.stdpath("config")
local lazyvim_path = config_path .. "/lua/lazyvim"

-- Ensure LazyVim config directory exists
vim.fn.system("mkdir -p " .. lazyvim_path)

-- Fetch LazyVim defaults from remote (or use local fallback)
vim.fn.system("bash " .. vim.fn.stdpath("data") .. "/scripts/fetch-lazyvim-config.sh")

-- Initialize LazyVim with remote + local configuration
require("lazyvim").setup {
  -- Diagnostics
  diagnostics = {
    -- Enable diagnostics for all buffers
    enabled = true,
    
    -- Virtual text settings
    virtual_text = {
      enabled = true,
      update_in_insert = true,
    },
    
    -- Severity sorting
    severity_sort = true,
    
    -- Signs configuration
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "✗",
        [vim.diagnostic.severity.WARN] = "⚠",
        [vim.diagnostic.severity.INFO] = "ℹ",
        [vim.diagnostic.severity.HINT] = "󰡘",
      },
    },
  },

  -- LSP Settings
  lsp = {
    -- Ensure diagnostics are always on
    default_keymaps = false, -- Let config/plugins.lua handle keymaps
    
    -- Inlay hints
    inlay_hints = {
      enabled = true,
    },

    -- Treesitter context
    treesitter = {
      enabled = true,
    },

    -- Hover settings
    hover = {
      border = "single",
    },

    -- Signature help
    signature = {
      enabled = true,
    },

    -- Document links
    document_link = {
      enabled = true,
    },

    -- Document highlight
    document_highlight = {
      enabled = true,
    },
  },

  -- Completion Settings
  completion = {
    enabled = true,
    
    -- Snippet expansion
    snippet = {
      enable = true,
      expand = function(args)
        vim.snippet.expand(args.body)
      end,
    },
    
    -- Documentation
    documentation = {
      enabled = true,
      border = "single",
    },
    
    -- Keymaps
    keymaps = {
      ["<C-n>"] = "<cmd>lua vim.fn.vim.lsp.buf_completion()<cr>",
      ["<C-p>"] = "<cmd>lua vim.lsp.buf.signature_help()<cr>",
    },
  },

  -- UI Settings
  ui = {
    border = "single",
    indent = {
      enabled = true,
      highlight = "Comment",
      shift = 2,
    },
    numbers = {
      enabled = true,
      virtual_text = true,
    },
    scrollbar = {
      enabled = true,
    },
    side_buffer = {
      enabled = true,
      width = 30,
    },
  },

  -- File explorer settings
  file_explorer = {
    use_libuv = true,
    use_native = true,
    options = {
      show_hidden = true,
      sort_by = "name",
    },
  },

  -- Git integration
  git = {
    keymaps = {
      ["gG"] = "<cmd>Git blame<cr>",
      ["gg"] = "<cmd>Telescope git commits<cr>",
      ["gc"] = "<cmd>Telescope git changes<cr>",
    },
  },

  -- Telescope configuration
  telescope = {
    defaults = {
      mappings = {
        n = {
          ["<C-q>"] = "<cmd>Telescope close<cr>",
        },
      },
    },
  },
}

-- =============================================================================
-- Local Overrides (merge after LazyVim setup)
-- =============================================================================

-- Override any specific settings here
local M = {}

function M.override_diagnostics()
  -- Example: Customize diagnostic signs
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "E",
        [vim.diagnostic.severity.WARN] = "W",
        [vim.diagnostic.severity.INFO] = "I",
        [vim.diagnostic.severity.HINT] = "H",
      },
    },
  })
end

function M.override_keymaps()
  -- Example: Add custom keymaps
  vim.keymap.set("n", "<leader>dd", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Quickfix" })
  vim.keymap.set("n", "<leader>qf", "<cmd>Telescope diagnostics.buf<cr>", { desc = "Quickfix telescope" })
end

-- Apply overrides
M.override_diagnostics()
M.override_keymaps()

return M
