return {
  {
    "obsidian-nvim/obsidian.nvim",
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- Optional.
      "folke/snacks.nvim",
      "saghen/blink.cmp",
      "nvim-treesitter/nvim-treesitter",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "programming",
          path = "~/vaults/programming",
        },
        {
          name = "work",
          path = "~/vaults/work",
        },
      },
    },
  },
}
