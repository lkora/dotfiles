-- =============================================================================
-- LazyVim Plugin Configuration
-- =============================================================================

-- LazyVim core with enhanced config
LuaSec.enable_linting = true

-- Keymaps
Keymap.set("n", "<Space>", "<Nop>", { desc = "Buffer/Tab/Line picker (space)" })
Keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close buffer" })
Keymap.set("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Close all buffers" })
Keymap.set("n", "<leader>ss", "<cmd>setlocal spell!<cr>", { desc = "Toggle spellcheck" })
Keymap.set("n", "<leader>ws", "<cmd>setlocal wrap!<cr>", { desc = "Toggle wrap" })
Keymap.set("n", "<leader>l", "<cmd>Telescope finders.files<cr>", { desc = "Find files" })

-- LSP Config
LspConfig.setup {
  -- Diagnostics
  diagnostics = {
    virtual_text = {
      update_in_insert = true,
    },
  },

  -- Treesitter
  treesitter = {
    auto_install = true,
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "css",
      "dockerfile",
      "html",
      "javascript",
      "lua",
      "markdown",
      "python",
      "rust",
      "sql",
      "typescript",
      "vim",
      "yaml",
    },
  },

  -- Completion
  completion = {
    documentation = true,
    snippet = {
      expand = function(args)
        vim.snippet.expand(args.body)
      end,
    },
  },
}

-- File explorer (Neovide native)
FileExplorer.setup {
  window = {
    position = "bottom",
  },
}

-- Git integration
Git.setup {
  keymaps = {
    ["gG"] = "<cmd>Git blame<cr>",
    ["gg"] = "<cmd>Telescope git commits<cr>",
  },
}

-- Telescope config
Telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["<C-q>"] = "<cmd>Telescope close<cr>",
      },
    },
  },
}
