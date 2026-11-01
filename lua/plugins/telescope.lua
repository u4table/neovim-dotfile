local function set_telescope_highlights()
	local h = vim.api.nvim_set_hl
	local bg_main = "#1e1e1e"
	local bg_prompt = "#252526"
	local bg_preview = "#2d2d30" -- slightly lighter than prompt
	local fg = "#d4d4d4"
	-- Prompt
	h(0, "TelescopePromptBorder", { fg = bg_prompt, bg = bg_prompt })
	h(0, "TelescopePromptNormal", { fg = fg, bg = bg_prompt })
	h(0, "TelescopePromptTitle", { fg = bg_main, bg = "#569cd6", bold = true })
	h(0, "TelescopePromptPrefix", { fg = "#569cd6", bg = bg_prompt })

	-- Results
	h(0, "TelescopeResultsBorder", { fg = bg_main, bg = bg_main })
	h(0, "TelescopeResultsNormal", { fg = fg, bg = bg_main })
	h(0, "TelescopeResultsTitle", { fg = bg_main, bg = bg_main })

	-- Preview (fully hidden border)
	h(0, "TelescopePreviewBorder", { fg = bg_preview, bg = bg_preview })
	h(0, "TelescopePreviewNormal", { fg = fg, bg = bg_preview })
	h(0, "TelescopePreviewTitle", { fg = bg_main, bg = "#6a9955", bold = true })

	-- Selection
	h(0, "TelescopeSelection", { bg = "#264f78", fg = fg })
	h(0, "TelescopeSelectionCaret", { fg = "#f44747", bg = "#264f78" })
	h(0, "TelescopeMultiSelection", { fg = "#6a9955" })

	-- Matching
	h(0, "TelescopeMatching", { fg = "#d7ba7d", bold = true })
end

local function keymaps()
	local bindkey = require("utils.util").bind_noremap
	local builtin = require("telescope.builtin")

	bindkey("n", "<leader><cr>", "<cmd>Telescope <cr>", "Telescope open")
	bindkey("n", "<leader>ff", "<cmd>Telescope find_files <cr>", "Telescope find files")
	bindkey("n", "<leader>fg", "<cmd>Telescope live_grep <cr>", "Telescope live grep")
	bindkey("n", "<leader>fb", "<cmd>Telescope buffers <cr>", "Telescope list buffers")
	bindkey("n", "<leader>fh", "<cmd>Telescope help_tags <cr>", "Telescope help tags")
	bindkey("n", "<leader>fo", "<cmd>Telescope oldfiles <cr>", "Telescope old files")
	bindkey("n", "<leader>fm", "<cmd>Telescope marks <cr>", "Telescope bookmarks")
	bindkey("n", "<leader>fd", "<cmd>Telescope diagnostics <cr>", "Telescope diagnostics")
	bindkey("n", "<leader>fk", "<cmd>Telescope keymaps <cr>", "Telescope keymaps")
	bindkey("n", "<leader>fz", "<cmd>Telescope lsp_document_symbols <cr>", "Telescope LSP document symbols")
	bindkey("n", "<leader>/", function()
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			previewer = false,
			layout_config = { width = 0.7 },
		}))
	end, "Telescope fuzzy search current buffer")
	bindkey("n", "<leader>gf", "<cmd>Telescope git_files <cr>", "Telescope git files")
	bindkey("n", "<leader>gc", "<cmd>Telescope git_commits <cr>", "Telescope git commits")
	bindkey("n", "<leader>gb", "<cmd>Telescope git_branches <cr>", "Telescope git branches")
	bindkey("n", "<leader>gs", "<cmd>Telescope git_status <cr>", "Telescope git status")
end

local function override_lsp_keymaps()
	local bindkey = require("utils.util").bind_noremap
	local builtin = require("telescope.builtin")

	bindkey("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
	-- bindkey("n", "gt", vim.lsp.buf.type_definition, "Goto type definition")
	bindkey("n", "gd", builtin.lsp_definitions, "Goto definition")
	bindkey("n", "grr", builtin.lsp_references, "Goto references")
	bindkey("n", "gi", builtin.lsp_implementations, "Goto implementations")
	bindkey("n", "<leader>ls", builtin.lsp_document_symbols, "Show document symbols")
	bindkey("n", "<leader>lw", builtin.lsp_workspace_symbols, "Show workspace symbols")
	bindkey("n", "gk", vim.lsp.buf.hover, "Hover document")
	bindkey("n", "grn", vim.lsp.buf.rename, "Rename symbol")
	bindkey({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
end

local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup({
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		entry_prefix = "  ",
		multi_icon = " ",

		sorting_strategy = "ascending", -- results flow downward from prompt
		layout_strategy = "bottom_pane",
		layout_config = {
			bottom_pane = {
				height = 25,
				preview_cutoff = 120,
				prompt_position = "top",
			},
		},
		-- layout_strategy = "vertical",
		-- layout_config = {
		-- 	vertical = {
		-- 		width = 0.8,
		-- 		height = 0.9,
		-- 		preview_height = 0.4, -- preview takes 40% of the total height
		-- 		preview_cutoff = 20,
		-- 		prompt_position = "top",
		-- 		mirror = true, -- flips preview to the bottom
		-- 	},
		-- },
		borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
	},

	set_env = { ["COLORTERM"] = "truecolor" },
	winblend = 0,
	color_devicons = false,
	use_less = true,
	border = true,

	file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
	file_sorter = require("telescope.sorters").get_fuzzy_file,
	file_previewer = require("telescope.previewers").vim_buffer_cat.new,
	grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
	qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
	buffer_preview_maker = require("telescope.previewers").buffer_previewer_maker,
	extensions = {
		fzf = {
			fuzzy = false,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
	pickers = {
		find_files = {
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
		live_grep = {
			addtional_args = function()
				return { "--hidden" }
			end,
		},
		buffers = {
			show_all_buffers = true,
			show_mru = true,
			sort_lastused = true,
			mappings = {
				i = {
					["<C-d>"] = actions.delete_buffer,
				},
				n = {
					["dd"] = actions.delete_buffer,
				},
			},
		},
	},
})

telescope.load_extension("fzf")
-- telescope.load_extension("live_grep_args")

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_telescope_highlights,
})

set_telescope_highlights()
keymaps()
override_lsp_keymaps()
