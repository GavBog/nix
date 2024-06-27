return {
  -- Install Ferris.nvim
  {
    'vxpm/ferris.nvim',
    ft = { "rust" },
    keys = {
      {
        "<leader>rr",
        desc = "Rust",
      },
      {
        "<leader>rre",
        "<cmd>FerrisExpandMacro<cr>",
        desc = "Expand macro",
      },
      {
        "<leader>rrm",
        "<cmd>FerrisViewMemoryLayout<cr>",
        desc = "View memory layout",
      },
      {
        "<leader>rrc",
        "<cmd>FerrisOpenCargoToml<cr>",
        desc = "Open Cargo.toml",
      },
      {
        "<leader>rrp",
        "<cmd>FerrisOpenParentModule<cr>",
        desc = "Open parent module",
      },
      {
        "<leader>rrd",
        "<cmd>FerrisOpenDocumentation<cr>",
      },
      {
        "<leader>rrr",
        "<cmd>FerrisReloadWorkspace<cr>",
        desc = "Reload workspace",
      },
    },
    opts = {
      -- If true, will automatically create commands for each LSP method
      create_commands = true,   -- bool
      -- Handler for URL's (used for opening documentation)
      url_handler = "xdg-open", -- string | function(string)
    },
  },
  {
    "mrcjkb/rustaceanvim",
    enabled = false,
  }
}
