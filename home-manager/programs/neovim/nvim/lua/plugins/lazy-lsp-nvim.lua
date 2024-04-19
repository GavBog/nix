return {
  {
    "dundalek/lazy-lsp.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings to learn the available actions
        lsp_zero.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false
        })

        -- enable formatting on save
        lsp_zero.async_autoformat(client, bufnr)
      end)

      require("lazy-lsp").setup {
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
      }
    end,
  },
}
