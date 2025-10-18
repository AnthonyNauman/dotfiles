return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		CustomOilBar = function()
			local path = vim.fn.expand("%")
			path = path:gsub("oil://", "")

			return "  " .. vim.fn.fnamemodify(path, ":.")
		end

		require("oil").setup({
			columns = { "icon" },
			keymaps = {
				["<C-h>"] = false,
				["<C-l>"] = false,
				["<C-k>"] = false,
				["<C-j>"] = false,
				["<A-l>"] = "actions.select_vsplit",
				["<A-h>"] = "actions.select_split",
				["<leader>e"] = "actions.close",
			},
			win_options = {
				winbar = "%{v:lua.CustomOilBar()}",
			},
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, _)
					local folder_skip = {}
					return vim.tbl_contains(folder_skip, name)
				end,
			},
		})

		vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
