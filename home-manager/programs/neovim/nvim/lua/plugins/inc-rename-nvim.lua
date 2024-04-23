return {
  {
    "smjonas/inc-rename.nvim",
    keys = {
      {
        "<leader>cn",
        ":IncRename ",
        desc = "Rename Symbol",
      }
    },
    config = function()
      require("inc_rename").setup()
    end,
  }
}
