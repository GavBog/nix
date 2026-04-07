return {
	{
		"saghen/blink.cmp",
		build = "nix run .#build-plugin",
		opts = {
			fuzzy = {
				sorts = { "exact", "score", "sort_text", "label", "kind" },
			},
			sources = {
				providers = {
					copilot = {
						score_offset = -1,
					},
				},
			},
		},
	},
}
