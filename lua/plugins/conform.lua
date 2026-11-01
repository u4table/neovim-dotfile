require("conform").setup({
	formatters_by_ft = {
		-- Lua
		lua = { "stylua", "luaformatter" },
		cpp = { "clang-format" },
		go = { "goimports", "gofumpt" },
		typescript = { "prettierd", "prettier", "ts-standard" },
		javascript = { "prettierd", "prettier" },
		reacttypescript = { "prettierd", "prettier", "ts-standard" },
		reactjavascript = { "prettierd", "prettier" },
	},
	format_on_save = { timeout_ms = 500 },
	default_format_opts = {
		lsp_format = "fallback",
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
	log_level = vim.log.levels.ERROR,
})

local bind = require("core.utils").bind_noremap
bind("n", "<leader>cf", function()
	require("conform").format({ async = true })
end, "Format buffer")
