return {
  -- Install Ferris.nvim
  {
    'vxpm/ferris.nvim',
    ft = { "rust" },
    keys = {
      {
        "<leader>cr",
        desc = "Rust",
      },
      {
        "<leader>cre",
        "<cmd>FerrisExpandMacro<cr>",
        desc = "Expand macro",
      },
      {
        "<leader>crm",
        "<cmd>FerrisViewMemoryLayout<cr>",
        desc = "View memory layout",
      },
      {
        "<leader>crc",
        "<cmd>FerrisOpenCargoToml<cr>",
        desc = "Open Cargo.toml",
      },
      {
        "<leader>crp",
        "<cmd>FerrisOpenParentModule<cr>",
        desc = "Open parent module",
      },
      {
        "<leader>crd",
        "<cmd>FerrisOpenDocumentation<cr>",
      },
      {
        "<leader>crr",
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
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      src = {
        cmp = { enabled = true },
      },
    },
  },
}
