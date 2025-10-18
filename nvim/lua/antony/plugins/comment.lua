return {
	"numToStr/Comment.nvim",
	config = function()
		vim.keymap.set("x", "<C-/>", function()
			local start_line = vim.fn.line("v")
			local end_line = vim.fn.line(".")

			for lnum = math.min(start_line, end_line), math.max(start_line, end_line) do
				vim.api.nvim_win_set_cursor(0, { lnum, 0 })
				require("Comment.api").toggle.linewise.current()
			end
		end, { desc = "Comment lines" })

		vim.keymap.set("n", "<C-/>", function()
			require("Comment.api").toggle.linewise.current()
		end, { noremap = true, silent = true, desc = "Toggle comment on current line" })

		vim.keymap.set(
			"x",
			"<leader>c/",
			'<ESC><cmd>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<CR>gv',
			{
				desc = "Toggle block comment",
			}
		)
	end,
	opts = {},
}
