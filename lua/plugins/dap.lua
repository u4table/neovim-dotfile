-- Debug Adapter Protocol setup (nvim-dap + dap-ui + dap-go)

local dap = require("dap")
local dapui = require("dapui")

require("nvim-dap-virtual-text").setup({})
dapui.setup()

-- Go: uses `dlv` from PATH (go install github.com/go-delve/delve/cmd/dlv@latest)
require("dap-go").setup({
	dap_configurations = {
		{
			type = "go",
			name = "Attach remote (:2345)",
			mode = "remote",
			request = "attach",
			connect = { host = "127.0.0.1", port = 2345 },
		},
	},
	delve = {
		path = "dlv",
		initialize_timeout_sec = 20,
		port = "${port}",
	},
})

-- Open/close dap-ui automatically
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })

local bind = require("utils.util").bind_noremap

bind("n", "<F5>", dap.continue, "Debug start/continue")
bind("n", "<F10>", dap.step_over, "Debug step over")
bind("n", "<F11>", dap.step_into, "Debug step into")
bind("n", "<F12>", dap.step_out, "Debug step out")
bind("n", "<leader>db", dap.toggle_breakpoint, "Debug toggle breakpoint")
bind("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Condition: "))
end, "Debug conditional breakpoint")
bind("n", "<leader>dl", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end, "Debug log point")
bind("n", "<leader>dc", dap.continue, "Debug start/continue")
bind("n", "<leader>dC", dap.run_to_cursor, "Debug run to cursor")
bind("n", "<leader>dr", dap.restart, "Debug restart")
bind("n", "<leader>dq", dap.terminate, "Debug terminate")
bind("n", "<leader>du", dapui.toggle, "Debug toggle UI")
bind("n", "<leader>dx", dap.clear_breakpoints, "Debug clear breakpoints")
bind({ "n", "v" }, "<leader>de", dapui.eval, "Debug eval expression")
