return {
  -- Install Ferris.nvim
  {
    'vxpm/ferris.nvim',
    ft = { "rust" },
    keys = {
      {
        "<leader>vm",
        "<cmd>FerrisViewMemoryLayout<cr>",
        desc = "View memory layout",
      },
    },
    opts = {
      -- If true, will automatically create commands for each LSP method
      create_commands = true,   -- bool
      -- Handler for URL's (used for opening documentation)
      url_handler = "xdg-open", -- string | function(string)
    },
  },

  -- Install Crates.nvim
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      src = {
        cmp = { enabled = true },
      },
    },
  }
}
