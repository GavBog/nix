-- Good for generating boilerplate http server code
-- Not going to make a habit of using it, but it's cool technology
return {
  {
    "yetone/avante.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      --- The below dependencies are optional,
      "folke/snacks.nvim",
      "saghen/blink.compat",
      "saghen/blink.cmp",
      "echasnovski/mini.icons",
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      "MeanderingProgrammer/render-markdown.nvim",
    },
    lazy = true,
    event = "VeryLazy",
    build = "make",

    opts = {
      hints = { enabled = false },
      provider = "copilot",
      file_selector = {
        provider = "snacks",
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { "Avante" },
    },
    ft = { "Avante" },
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      'Kaiser-Yang/blink-cmp-avante',
    },
    opts = {
      sources = {
        default = { 'avante' },
        providers = {
          avante = {
            module = 'blink-cmp-avante',
            name = 'Avante',
            opts = {
              -- options for blink-cmp-avante
            }
          }
        },
      }
    }
  }
}
