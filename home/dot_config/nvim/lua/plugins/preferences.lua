return {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-mocha" } },
  {
    "neovim/nvim-lspconfig",
    opts = { diagnostics = { virtual_text = true, severity_sort = true } },
  },
  -- Host editing works without a compiler. Development boxes enable parsers.
  { "nvim-treesitter/nvim-treesitter", enabled = vim.fn.executable("cc") == 1 },
}
