local normalFg = "#DFDFDF"

require("gruvbox").setup({
	terminal_colors = true,
	bold = false,
	italic = {
		strings = false,
		comments = true,
		emphasis = false,
		operators = false,
		folds = false,
	},
	transparent_mode = true,
	overrides = {
		["GruvboxRed"] = { fg = "#FF6666" },
		["Identifier"] = { fg = normalFg },
		["Field"] = { fg = normalFg },
		["Macro"] = { fg = normalFg },
		["Structure"] = { fg = normalFg },
		["Normal"] = { fg = normalFg },
		["Constant"] = { fg = normalFg },
		["Character"] = { fg = normalFg },
		["@lsp.type.method"] = { bg = "#ff9900" },
	},
})

--vim.o.background = "dark" -- or "light" for light mode
-- vim.cmd([[colorscheme vscode-mordern]])
-- vim.cmd([[ colorscheme my-unokai ]])
vim.cmd([[ colorscheme vscode_modern ]])
-- vim.cmd([[ colorscheme darcula ]])
