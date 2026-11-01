-- Configure for go filetype

local vim = vim
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = false
vim.opt_local.textwidth = 120

local bind = require("utils.util").bind_buf_noremap
local gotest = require("plugins.gotest")
local bufnr = vim.api.nvim_get_current_buf()

-- Run tests
bind("n", "<leader>tt", gotest.test_nearest, bufnr, "Go test nearest")
bind("n", "<leader>tf", gotest.test_file, bufnr, "Go test file")
bind("n", "<leader>tp", gotest.test_package, bufnr, "Go test package")
bind("n", "<leader>ta", gotest.test_all, bufnr, "Go test all")
bind("n", "<leader>tl", gotest.test_last, bufnr, "Go test last")
bind("n", "<leader>tc", gotest.test_coverage, bufnr, "Go test coverage")

-- Debug tests (nvim-dap-go)
bind("n", "<leader>dt", function()
	require("dap-go").debug_test()
end, bufnr, "Debug Go test nearest")
bind("n", "<leader>dT", function()
	require("dap-go").debug_last_test()
end, bufnr, "Debug Go test last")

-- Run / build
bind("n", "<leader>gr", "<CMD>GoRun<CR>", bufnr, "Go run package")
bind("n", "<leader>gt", "<CMD>GoModTidy<CR>", bufnr, "Go mod tidy")
bind("n", "<leader>gi", require("plugins.goimpl").implement, bufnr, "Go implement interface")

-- Toggle inlay hints
bind("n", "<leader>ih", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end, bufnr, "Toggle inlay hints")
