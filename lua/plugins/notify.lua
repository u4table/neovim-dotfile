local fidget = require("fidget")

fidget.setup({
	-- Show LSP progress (e.g. gopls indexing)
	progress = {
		display = {
			done_ttl = 1,
		},
	},
	notification = {
		-- Route all `vim.notify()` calls through fidget
		override_vim_notify = true,
		-- window = {
		-- 	border = "rounded",
		-- 	winblend = 0,
		-- 	max_width = 0.4,
		-- },
	},
})

local bind = require("utils.util").bind_noremap
bind("n", "<leader>nh", "<CMD>Fidget history<CR>", "Notification history")
bind("n", "<leader>nc", "<CMD>Fidget clear<CR>", "Clear notifications")
