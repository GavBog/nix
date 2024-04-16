return {
  -- Install Ferris.nvim
  {
    'vxpm/ferris.nvim',
    ft = { "rust" },
    keys = {
      {
        "<leader>fE",
        "<cmd>FerrisExpandMacro<cr>",
        desc = "Expand macro",
      },
      {
        "<leader>fm",
        "<cmd>FerrisViewMemoryLayout<cr>",
        desc = "View memory layout",
      },
      {
        "<leader>fC",
        "<cmd>FerrisOpenCargoToml<cr>",
        desc = "Open Cargo.toml",
      },
      {
        "<leader>fp",
        "<cmd>FerrisOpenParentModule<cr>",
        desc = "Open parent module",
      },
      {
        "<leader>fd",
        "<cmd>FerrisOpenDocumentation<cr>",
      },
      {
        "<leader>fw",
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

  -- Uninstall Rustaceanvim
  {
    "mrcjkb/rustaceanvim",
    enabled = false,
  },
}
