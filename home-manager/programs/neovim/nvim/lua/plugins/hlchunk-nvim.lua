return {
  {
    "shellRaining/hlchunk.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('hlchunk').setup({
        chunk = {
          enable = true,
          use_treesitter = true,
        },
        indent = {
          enable = true,
          use_treesitter = true,
        },
        line_num = {
          enable = true,
          use_treesitter = true,
        }
      })
    end
  },
}
