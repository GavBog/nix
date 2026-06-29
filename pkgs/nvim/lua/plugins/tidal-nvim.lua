return {
	{
		"https://codeberg.org/MrReason/tidal.nvim",
		lazy = true,
		ft = "tidal",
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, { "haskell" })
			vim.treesitter.language.register("haskell", "tidal")
		end,
	},
}
