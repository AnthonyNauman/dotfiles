local utils = require("antony.utils.functions")

return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },

		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		{ "andrew-george/telescope-themes" },
	},
	config = function()
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		local telescope = require("telescope")
		telescope.load_extension("themes")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = { -- (insert mode)
						["<C-k>"] = require("telescope.actions").move_selection_previous,
						["<C-j>"] = require("telescope.actions").move_selection_next,
						["<A-k>"] = require("telescope.actions").move_selection_previous,
						["<A-j>"] = require("telescope.actions").move_selection_next,
						["<Esc>"] = "close",
						["<A-l>"] = "select_vertical",
						["<C-l>"] = "select_vertical",
						["<A-h>"] = "select_horizontal",
						["<C-h>"] = "select_horizontal",
					},
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				themes = {
					enable_previewer = true,
					enable_live_preview = true,
					persist = {
						enabled = true,
						path = vim.fn.stdpath("config") .. "/lua/theme/current-theme.lua",
					},
				},
			},
		})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
		vim.keymap.set(
			"n",
			"<leader>sc",
			"<cmd>Telescope themes<CR>",
			{ noremap = true, silent = true, desc = "[S]earch [C]olorsheme Telescope" }
		)

		vim.keymap.set("n", "<leader>sw", function()
			builtin.grep_string({ cwd = utils.get_startup_path() })
		end, { desc = "[S]earch current [W]ord" })

		vim.keymap.set("n", "<leader>sf", function()
			builtin.find_files({ cwd = utils.get_startup_path() })
		end, { desc = "[S]earch [F]iles" })

		vim.keymap.set("n", "<leader>sg", function()
			builtin.live_grep({ cwd = utils.get_startup_path() })
		end, { desc = "[S]earch by [G]rep" })

		-- Grep in all files in ~/
		vim.keymap.set("n", "<leader>sW", function()
			builtin.grep_string({ cwd = utils.get_workbench() })
		end, { desc = "[S]earch current [W]ord in workbench" })

		vim.keymap.set("n", "<leader>sF", function()
			builtin.find_files({ cwd = get_workbench() })
		end, { desc = "[S]earch [F]iles in workbench" })

		vim.keymap.set("n", "<leader>sG", function()
			builtin.live_grep({ cwd = utils.get_workbench() })
		end, { desc = "[S]earch by [G]rep in workbench" })

		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 8,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })

		vim.keymap.set("n", "<leader>sT", function()
			vim.cmd("TodoTelescope cwd=" .. utils.get_startup_path())
		end, { desc = "[S]earch [T]odos Tree in workdir" })

		vim.keymap.set("n", "<leader>st", function()
			vim.cmd("TodoTelescope cwd=" .. utils.get_curr_file_folder_path())
		end, { desc = "[S]earch [T]odos in current file" })

		local harpoon = require("harpoon")
		local conf = require("telescope.config").values
		local themes = require("telescope.themes")

		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end
			local opts = themes.get_ivy({
				promt_title = "Working List",
			})

			require("telescope.pickers")
				.new(opts, {
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer(opts),
					sorter = conf.generic_sorter(opts),
				})
				:find()
		end

		vim.keymap.set("n", "<leader>hh", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Open [H]arpoon window" })
	end,
}
