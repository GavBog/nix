return {
  {
    "tidalcycles/vim-tidal",
    lazy = true,
    ft = "tidal",
    keys = function()
      local keys = {}
      -- Play patterns (d1..d9)
      for i = 1, 9 do
        table.insert(keys, {
          string.format("<leader>tp%d", i),
          string.format("<cmd>TidalPlay %d<cr>", i),
          desc = string.format("Play d%d", i),
        })
      end
      -- Silence patterns (hush one pattern)
      for i = 1, 9 do
        table.insert(keys, {
          string.format("<leader>ts%d", i),
          string.format("<cmd>TidalSilence %d<cr>", i),
          desc = string.format("Silence d%d", i),
        })
      end
      -- Global hush
      table.insert(keys, { "<leader>th", "<cmd>TidalHush<cr>", desc = "Hush all" })
      table.insert(keys, { "<leader>ta", "<cmd>0,$TidalSend<cr>", desc = "Play File" })
      return keys
    end,
  },
}
