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

          -- RustaceanVim covers this
          "rust_analyzer"
        },
        preferred_servers = {
          astro = { "astro", "tailwindcss" },
          c = { "clangd" },
          cpp = { "clangd" },
          cs = { "omnisharp" },
          go = { "gopls" },
          haskell = { "hls" },
          javascript = { "ts_ls" },
          javascriptreact = { "ts_ls", "tailwindcss" },
          json = { "jsonls" },
          jsx = { "ts_ls", "tailwindcss" },
          nix = { "nil_ls" },
          proto = { "bufls" },
          python = { "pyright" },
          rust = { "rust_analyzer" },
          tsx = { "ts_ls", "tailwindcss" },
          typescript = { "ts_ls" },
          typescriptreact = { "ts_ls", "tailwindcss" },
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
    lazy = true,
    event = "VeryLazy",

    config = function()
      local lsp_zero = require("lsp-zero")

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false
        })

        -- set keymaps
        require("lazyvim.plugins.lsp.keymaps").on_attach(client, bufnr)
        vim.keymap.set('n', '<leader>cf', '<cmd>LspZeroFormat!<cr>', { buffer = bufnr })

        -- enable formatting on save
        lsp_zero.buffer_autoformat()
      end)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function() end,
  },
}
