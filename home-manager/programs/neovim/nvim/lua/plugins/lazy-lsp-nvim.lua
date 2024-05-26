return {
  {
    "dundalek/lazy-lsp.nvim",
    dependencies = {
      "VonHeikemen/lsp-zero.nvim",
    },
    lazy = true,
    event = "VeryLazy",
    config = function()
      require("lazy-lsp").setup {
        prefer_local = true,

        excluded_servers = {
          "diagnosticls",
          "efm",
          "ltex",
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

        configs = {
          rust_analyzer = {
            settings = {
              ["rust-analyzer"] = {
                checkOnSave = {
                  command = "clippy",
                },
              },
            },
          },
        }
      }
    end,
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
    },
    lazy = true,
    event = "LazyFile",

    config = function()
      local lsp_zero = require("lsp-zero")

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false
        })

        -- set keymaps
        vim.keymap.set('n', '<leader>cf', '<cmd>LspZeroFormat!<cr>', { buffer = bufnr })
        vim.keymap.set('n', '<leader>cl', '<cmd>LspInfo<cr>', { desc = "Lsp Info" })


        -- enable formatting on save
        lsp_zero.buffer_autoformat()
      end)
    end,
  }
}
