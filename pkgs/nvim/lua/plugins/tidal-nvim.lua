return {
  {
    "GavBog/tidal.nvim",
    lazy = true,
    ft = "tidal",
    opts = {
      filetype = "tidal",
    },
  },
  {
    "thgrund/tidal-makros.nvim",
    lazy = true,
    ft = "tidal",
    config = function()
      require("makros").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, { "haskell" })
      vim.treesitter.language.register("haskell", "tidal")
    end,
  },
}
