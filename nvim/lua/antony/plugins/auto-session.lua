return {
	"rmagatti/auto-session",
	lazy = false,
	opts = {
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		-- log_level = 'debug',
	},
	config = function()
		local auto_session = require("auto-session")
		auto_session.setup({
			auto_restore_enabled = false,
			-- auto_session_supress_dirs = { "~/", "/mnt/", "/tmp/", "/" },
		})
		vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "[R]estor session cwd" })
		vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "[S]ave session" })
	end,
}
