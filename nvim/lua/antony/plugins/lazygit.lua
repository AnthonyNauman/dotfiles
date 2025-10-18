local utils = require("antony.utils.functions")

return {
	"kdheepak/lazygit.nvim",
	lazy = true,
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "[L]azy[G]it" },
	},
	config = function()
		vim.keymap.set("n", "<leader>lg", function()
			local dir = utils.get_curr_file_folder_path() -- Директория текущего файла

			require("toggleterm.terminal").Terminal
				:new({
					cmd = "lazygit",
					dir = dir,
					direction = "float",
					size = 80,
					hidden = true,
					close_on_exit = true,
					on_open = function(term)
						vim.cmd("startinsert!")
					end,
				})
				:toggle()
		end, { desc = "Open LazyGit in current file dir" })
		-- require("lazygit").setup({
		-- Ваши кастомные настройки lazygit здесь
		-- })
	end,
}
