vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = false
vim.g.transparency = 0.55

vim.o.sw = 4
vim.o.sts = 4
vim.o.ts = 4
vim.o.et = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 150
vim.o.timeoutlen = 50
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

vim.opt.numberwidth = 1
vim.opt.statuscolumn = " %l    "
vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"

if vim.fn.executable("xclip") == 1 then
	vim.g.clipboard = {
		name = "xclip",
		copy = {
			["+"] = "xclip -selection clipboard",
			["*"] = "xclip -selection primary",
		},
		paste = {
			["+"] = "xclip -selection clipboard -o",
			["*"] = "xclip -selection primary -o",
		},
		cache_enabled = 1,
	}
end

-- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff9e64", bold = true })
