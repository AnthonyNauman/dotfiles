return {
	"echasnovski/mini.nvim",
	config = function()
		-- Better Around/Inside textobjects
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
		--  - yi(- - [Y]ank [I]nside [(]paren
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- -- - sr)'  - [S]urround [R]eplace [)] [']
		-- require("mini.surround").setup({
		-- opts = {
		-- mappings = {
		-- add = "sa", -- Add surrounding in Normal and Visual modes
		-- delete = "ds", -- Delete surroundings
		-- find_left = "sf", -- Find surrounding to the left
		-- find = "sF", -- Find surrounding to the right
		-- highlight = "sh", -- Highlight surroundings
		-- replace = "sr", -- Replace surrounding
		-- update_n_lines = "sn", -- Update n_lines
		--
		-- suffix_last = "l", -- Suffix to search with prev
		-- suffix_next = "n", -- Suffix to search with next
		-- },
		-- 	-- },
		-- })

		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })
		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v"
		end
	end,
}
