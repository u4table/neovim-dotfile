local highlight = {
	"Whitespace",
}

require("ibl").setup({
	indent = {
		char = "│",
		highlight = highlight,
	},
	scope = {
		enabled = false,
	},
})
