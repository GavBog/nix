return {
  {
    "dundalek/lazy-lsp.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("lazy-lsp").setup({
        prefer_local = true,
      })
    end,
  },
}
