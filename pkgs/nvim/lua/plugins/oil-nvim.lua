return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    lazy = true,
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Oil" },
    },
    opts = {
      skip_confirm_for_simple_edits = true,
    },
  },
}
