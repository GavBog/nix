return {
  {
    'Wansmer/treesj',
    lazy = true,
    keys = {
      { "<leader>m", "<cmd>TSJToggle<cr>", desc = "split/join block" },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      use_default_keymaps = false,
    }
  },
}
