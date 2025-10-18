return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			open_mapping = [[<F9>]],
			start_in_insert = true,
			hide_numbers = true,
			direction = "float", -- "horizontal", "vertical"
			-- direction = "horizontal",
		})
		vim.api.nvim_set_keymap(
			"n",
			"<F9>",
			":ToggleTerm dir=%:p:h<CR>",
			{ noremap = true, silent = true, desc = "Toggle Term" }
		)
	end,
}
