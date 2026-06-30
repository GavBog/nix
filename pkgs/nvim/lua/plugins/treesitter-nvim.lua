return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = require("nixCatsUtils").isNixCats and false or ":TSUpdate",
		opts = function(_, opts)
			local isNix = require("nixCatsUtils").isNixCats

			opts.auto_install = not isNix

			if isNix then
				opts.ensure_installed = {}
			end
		end,
	},
}
