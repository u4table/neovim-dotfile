require("lualine").setup({
	options = {
		icon_enabled = false,
		theme = "onedark",
		section_separators = "",
		component_separators = "|",
		disabled_filetypes = {
			statusline = { "neo-tree" },
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
			refresh_time = 16, -- ~60fps
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
			},
		},
	},
	sections = {
		lualine_a = {
			"mode",
		},
		lualine_b = {
			-- {
			-- 	"buffers",
			-- 	mode = 3,
			-- 	symbols = {
			-- 		modified = " ●", -- Text to show when the buffer is modified
			-- 		alternate_file = "#", -- Text to show to identify the alternate file
			-- 		directory = "", -- Text to show when the buffer is a directory
			-- 	},
			-- 	show_modified_status = true,
			-- },
			"branch",
			"diff",
			"diagnostics",
		},
		lualine_c = { { "filename", path = 1 } },
		lualine_x = {
			"encoding",
			{
				"fileformat",
				symbols = {
					unix = "unix",
					dos = "dos",
					mac = "osx",
				},
			},
			"filetype",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = { "buffers" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "tabs" },
	},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})
