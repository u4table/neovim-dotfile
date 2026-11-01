require("neo-tree").setup({
	close_if_last_window = true,
	window = {
		position = "left",
		width = 60,
		mapping_options = {
			noremap = true,
			nowait = true,
		},
	},
	default_component_configs = {
		container = {
			enable_character_fade = true,
		},
		indent = {
			indent_size = 2,
			padding = 1,
			with_markers = true,
			indent_marker = "│",
			last_indent_marker = "└",
			highlight = "NeoTreeIndentMarker",
			with_expanders = nil,
			expander_collapsed = "[+]",
			expander_expanded = "[-]",
			expander_highlight = "NeoTreeExpander",
		},
		icon = {
			-- folder_closed = "[-]",
			-- folder_open = "[+]",
			folder_closed = "",
			folder_open = "",
			folder_empty = "[]",
			default = "",
			highlight = "NeoTreeFileIcon",
		},
		modified = {
			symbol = "[M]",
			highlight = "NeoTreeModified",
		},
		name = {
			trailing_slash = false,
			use_git_status_colors = true,
			highlight = "NeoTreeFileName",
		},
		git_status = {
			symbols = {
				added = "[A]",
				modified = "[M]",
				deleted = "[D]",
				renamed = "[R]",
				untracked = "[U]",
				ignored = "[I]",
				unstaged = "[US]",
				staged = "[S]",
				conflict = "[C]",
			},
		},
	},
})

local bind = require("core.utils").bind_noremap
bind("n", "<leader>ee", "<cmd>Neotree reveal_force_cwd <cr>", "open file explorer")
bind("n", "<leader>ec", "<cmd>Neotree close  <cr>", "close file explorer")
