return {
  {
    "dundalek/lazy-lsp.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("lazy-lsp").setup({
        prefer_local = true,

        excluded_servers = {
          "diagnosticls",
          "efm",
          -- Bugged servers
          "sqls",
          "rome",
        },
        preferred_servers = {
          c = { "clangd" },
          cpp = { "clangd" },
          cs = { "omnisharp" },
          go = { "gopls" },
          haskell = { "hls" },
          javascript = { "tsserver" },
          javascriptreact = { "tsserver" },
          json = { "jsonls" },
          jsx = { "tsserver" },
          nix = { "nil_ls" },
          python = { "pyright" },
          rust = { "rust_analyzer" },
          tsx = { "tsserver" },
          typescript = { "tsserver" },
          typescriptreact = { "tsserver" },
          yaml = { "yamlls" },
        },
      })
    end,
  },
}
