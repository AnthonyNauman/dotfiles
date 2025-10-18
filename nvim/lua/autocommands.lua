-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	callback = function()
		require("lualine").refresh()
	end,
})

-- Switch between relative line numbers and normal numbers
local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", {})
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter", "CmdlineLeave" }, {
	group = numbertoggle,
	callback = function()
		if vim.opt.number and vim.api.nvim_get_mode() ~= "i" then
			vim.opt.relativenumber = true
		end
	end,
})

-- Switch between relative line numbers and normal numbers
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave", "CmdlineEnter" }, {
	group = numbertoggle,
	callback = function()
		if vim.opt.number then
			vim.opt.relativenumber = false
			vim.cmd("redraw")
		end
	end,
})

local listchars_group = vim.api.nvim_create_augroup("ListCharsToggle", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
	group = listchars_group,
	pattern = "*",
	callback = function()
		vim.opt.list = true
		vim.opt.listchars = {
			tab = "▸ ",
			trail = "·",
			extends = "❯",
			precedes = "❮",
			nbsp = "␣",
		}
	end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineEnter" }, {
	group = listchars_group,
	pattern = "*",
	callback = function()
		vim.opt.list = false
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
