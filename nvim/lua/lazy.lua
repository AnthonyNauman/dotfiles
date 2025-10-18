local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup(
    {
	"NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
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
				local dir = get_curr_file_folder_path() -- Директория текущего файла

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
	},
	{
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			spec = {
				{ "<leader>s", group = "[S]earch" },
				-- { "<leader>t", group = "[T]oggle" },
				-- { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},
	-- Fuzzy Finder (files, lsp, etc)
	{
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
							["<A-k>"] = require("telescope.actions").move_selection_previous,
							["<C-k>"] = require("telescope.actions").move_selection_previous,
							["<A-j>"] = require("telescope.actions").move_selection_next,
							["<C-j>"] = require("telescope.actions").move_selection_next,
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
							path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua",
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
				builtin.grep_string({ cwd = get_startup_path() })
			end, { desc = "[S]earch current [W]ord" })

			vim.keymap.set("n", "<leader>sf", function()
				builtin.find_files({ cwd = get_startup_path() })
			end, { desc = "[S]earch [F]iles" })

			vim.keymap.set("n", "<leader>sg", function()
				builtin.live_grep({ cwd = get_startup_path() })
			end, { desc = "[S]earch by [G]rep" })

			-- Grep in all files in ~/
			vim.keymap.set("n", "<leader>sW", function()
				builtin.grep_string({ cwd = get_workbench() })
			end, { desc = "[S]earch current [W]ord in workbench" })

			vim.keymap.set("n", "<leader>sF", function()
				builtin.find_files({ cwd = get_workbench() })
			end, { desc = "[S]earch [F]iles in workbench" })

			vim.keymap.set("n", "<leader>sG", function()
				builtin.live_grep({ cwd = get_workbench() })
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
				vim.cmd("TodoTelescope cwd=" .. get_startup_path())
			end, { desc = "[S]earch [T]odos Tree in workdir" })

			vim.keymap.set("n", "<leader>st", function()
				vim.cmd("TodoTelescope cwd=" .. get_curr_file_folder_path())
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
	},
	{
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
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
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
					["<A-j>"] = "actions.select_split",
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
	},
	{
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
	},
	{
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
	},
	-- LSP Plugins
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("<leader>gn", vim.lsp.buf.rename, "[R]e[n]ame")

					map("<leader>ga", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					map("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					map("<leader>gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					map("<leader>gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					map("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					map("<leader>o", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

					map(
						"<leader>gW",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"Open Workspace Symbols"
					)

					map("<leader>gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>H", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay [H]ints")
					end
				end,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = false,
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"clangd",
				"clang-format",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},
	-- Autocompletion
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {},
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "enter", ---@type 'enter' | 'default' | 'super-tab' | 'none'
				["<C-j>"] = { "select_next", "snippet_forward", "fallback" },
				["<C-k>"] = { "select_prev", "snippet_backward", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},

			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		},
	},

	-- FIXME: LuaLine
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
	-- Highlight todo, notes, etc in comments
	{
		-- TODO:
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
			search = { pattern = [[\b(KEYWORDS)]] },
			highlight = { pattern = [[.*<(KEYWORDS)\s*]] },
		},
		config = true,
	},
	{
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
	},
	-- Collection of various small independent plugins/modules
	{
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
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"python",
				"diff",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			-- Autoinstall languages that are not installed
			auto_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
	},
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
