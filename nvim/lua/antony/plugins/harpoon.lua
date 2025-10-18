return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local harpoon = require("harpoon")
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<leader>hm", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)
		vim.keymap.set("n", "<C-m>", function()
			harpoon:list():prev()
		end)
		vim.keymap.set("n", "<C-n>", function()
			local list = harpoon:list()
			if list:length() == 0 then
				return
			end
			local current_idx = 0
			for i, item in ipairs(list.items) do
				if item.value == vim.api.nvim_buf_get_name(0) then
					current_idx = i
					break
				end
			end
			list:select((current_idx % list:length()) + 1)
		end, { desc = "go next Harpoon" })
		vim.keymap.set("n", "<C-m>", function()
			local list = harpoon:list()
			local length = list:length()
			if length == 0 then
				return
			end
			local current_idx = 0
			for i, item in ipairs(list.items) do
				if item.value == vim.api.nvim_buf_get_name(0) then
					current_idx = i
					break
				end
			end
			list:select((current_idx - 2) % length + 1)
		end, { desc = "go prev Harpoon" })
	end,
}
