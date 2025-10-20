return {
  {
    "dundalek/lazy-lsp.nvim",
    lazy = true,
    event = "VeryLazy",
    opts = {
      prefer_local = false,
      use_vim_lsp_config = true,

      excluded_servers = {
        "diagnosticls",
        "efm",

        -- rustaceanvim handles this
        "rust_analyzer",
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
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function() end,
  },
}
