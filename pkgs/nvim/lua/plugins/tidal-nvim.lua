return {
  {
    "thgrund/tidal.nvim",
    lazy = true,
    ft = "tidal",
    opts = {
      -- Your configuration here
      -- See configuration section for defaults
    },
    -- Recommended: Install TreeSitter parsers for Haskell and SuperCollider
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = { ensure_installed = { "haskell", "supercollider" } },
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
}
