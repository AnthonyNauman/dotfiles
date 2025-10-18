return {
	{ "vague2k/vague.nvim" },
	{ "bettervim/yugen.nvim" },
	{ "p00f/alabaster.nvim" },
	{
		"lucasadelino/conifer.nvim",
		priority = 1000,
		lazy = false,
		opts = {},
	},
	{
		"olivercederborg/poimandres.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"behemothbucket/gruber-darker-theme.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("gruber-darker").setup()
		end,
	},
}
