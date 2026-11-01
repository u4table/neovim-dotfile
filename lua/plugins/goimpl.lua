-- Go: generate method stubs so the type under cursor implements an interface.
-- Inserts `var _ Iface = (*T)(nil)` after the type, then applies gopls's
-- "Declare missing methods of Iface" quickfix on that assertion.

local M = {}

local function gopls_client(bufnr)
	return vim.lsp.get_clients({ bufnr = bufnr, name = "gopls" })[1]
end

-- nearest `type Name ...` at/above cursor, and the line where its declaration ends
local function find_type()
	for i = vim.fn.line("."), 1, -1 do
		local line = vim.fn.getline(i)
		local name = line:match("^type%s+([%w_]+)")
		if name then
			local _, opens = line:gsub("{", "")
			local _, closes = line:gsub("}", "")
			if opens <= closes then
				return name, i
			end
			for j = i + 1, vim.fn.line("$") do
				if vim.fn.getline(j):match("^}") then
					return name, j
				end
			end
			return name, i
		end
	end
	return nil
end

local function organize_imports(bufnr, client, lnum)
	local params = {
		textDocument = vim.lsp.util.make_text_document_params(bufnr),
		range = { start = { line = lnum - 1, character = 0 }, ["end"] = { line = lnum - 1, character = 0 } },
		context = { only = { "source.organizeImports" }, diagnostics = {} },
	}
	local res = client:request_sync("textDocument/codeAction", params, 5000, bufnr)
	for _, action in ipairs(res and res.result or {}) do
		if action.edit then
			vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
		end
	end
end

local function implement(bufnr, client, type_name, end_lnum, iface)
	local assertion = string.format("var _ %s = (*%s)(nil)", iface, type_name)
	vim.api.nvim_buf_set_lines(bufnr, end_lnum, end_lnum, false, { "", assertion })

	local function find_assertion()
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		for i, l in ipairs(lines) do
			if l == assertion then
				return i
			end
		end
	end

	local function rollback(msg)
		local lnum = find_assertion()
		if lnum then
			vim.api.nvim_buf_set_lines(bufnr, lnum - 2, lnum, false, {})
		end
		vim.notify(msg, vim.log.levels.ERROR)
	end

	-- add the import for a package-qualified interface (e.g. io.Reader)
	if iface:find(".", 1, true) then
		organize_imports(bufnr, client, find_assertion())
	end

	-- wait for gopls to report the type error on the assertion line
	local lnum, diag
	vim.wait(5000, function()
		lnum = find_assertion()
		if not lnum then
			return true
		end
		for _, d in ipairs(vim.diagnostic.get(bufnr, { lnum = lnum - 1 })) do
			if d.message:match("does not implement") or d.message:match("undefined") then
				diag = d
				return true
			end
		end
		return false
	end, 100)

	if not diag then
		vim.notify(type_name .. " already implements " .. iface)
		return
	end
	if not diag.message:match("does not implement") then
		rollback(diag.message)
		return
	end

	vim.api.nvim_win_set_cursor(0, { lnum, diag.col })
	vim.lsp.buf.code_action({
		context = { only = { "quickfix" }, diagnostics = { diag.user_data.lsp } },
		filter = function(action)
			return action.title:match("^Declare missing methods") ~= nil
		end,
		apply = true,
	})
end

function M.implement(iface)
	local bufnr = vim.api.nvim_get_current_buf()
	local client = gopls_client(bufnr)
	if not client then
		vim.notify("gopls is not attached", vim.log.levels.WARN)
		return
	end
	local type_name, end_lnum = find_type()
	if not type_name then
		vim.notify("No type declaration found at/above cursor", vim.log.levels.WARN)
		return
	end

	if iface and iface ~= "" then
		implement(bufnr, client, type_name, end_lnum, iface)
		return
	end
	vim.ui.input({ prompt = "Implement interface for " .. type_name .. ": " }, function(input)
		if input and input ~= "" then
			implement(bufnr, client, type_name, end_lnum, vim.trim(input))
		end
	end)
end

vim.api.nvim_create_user_command("GoImpl", function(opts)
	M.implement(opts.args)
end, { nargs = "?", desc = "Implement Go interface for type under cursor" })

return M
