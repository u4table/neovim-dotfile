-- Go test runner: runs `go test` in a terminal split

local M = {}

local last_cmd = nil
local last_cwd = nil
local term_buf = nil

local function run_in_term(cmd, cwd)
	last_cmd, last_cwd = cmd, cwd
	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		vim.api.nvim_buf_delete(term_buf, { force = true })
	end
	vim.cmd("botright 15split")
	vim.cmd("enew")
	term_buf = vim.api.nvim_get_current_buf()
	vim.fn.jobstart(cmd, { term = true, cwd = cwd })
	vim.bo[term_buf].bufhidden = "wipe"
	vim.keymap.set("n", "q", "<CMD>close<CR>", { buffer = term_buf, silent = true, desc = "Close test output" })
	vim.cmd("normal! G")
	vim.cmd("wincmd p")
end

local function pkg_dir()
	return vim.fn.expand("%:p:h")
end

-- find nearest `func TestXxx(` / `func BenchmarkXxx(` / `func FuzzXxx(` above cursor
local function nearest_test()
	local lnum = vim.fn.line(".")
	for i = lnum, 1, -1 do
		local line = vim.fn.getline(i)
		local name = line:match("^func%s+(Test%w*)%s*%(")
			or line:match("^func%s+(Benchmark%w*)%s*%(")
			or line:match("^func%s+(Fuzz%w*)%s*%(")
		if name then
			return name
		end
	end
	return nil
end

-- find all test funcs in current buffer
local function file_tests()
	local names = {}
	for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
		local name = line:match("^func%s+(Test%w*)%s*%(")
		if name then
			table.insert(names, name)
		end
	end
	return names
end

local function go_test(args)
	local cmd = { "go", "test", "-v", "-count=1" }
	vim.list_extend(cmd, args)
	run_in_term(cmd, pkg_dir())
end

function M.test_nearest()
	local name = nearest_test()
	if not name then
		vim.notify("No test function found above cursor", vim.log.levels.WARN)
		return
	end
	if name:match("^Benchmark") then
		go_test({ "-run", "^$", "-bench", "^" .. name .. "$", "." })
	else
		go_test({ "-run", "^" .. name .. "$", "." })
	end
end

function M.test_file()
	local names = file_tests()
	if #names == 0 then
		vim.notify("No test functions in this file", vim.log.levels.WARN)
		return
	end
	go_test({ "-run", "^(" .. table.concat(names, "|") .. ")$", "." })
end

function M.test_package()
	go_test({ "." })
end

function M.test_all()
	local root = vim.fs.root(0, { "go.work", "go.mod" }) or vim.fn.getcwd()
	run_in_term({ "go", "test", "-count=1", "./..." }, root)
end

function M.test_last()
	if not last_cmd then
		vim.notify("No previous test run", vim.log.levels.WARN)
		return
	end
	run_in_term(last_cmd, last_cwd)
end

function M.test_coverage()
	local out = vim.fn.tempname() .. ".out"
	local dir = pkg_dir()
	local cmd = string.format(
		"go test -count=1 -coverprofile=%s . && go tool cover -func=%s && go tool cover -html=%s",
		out,
		out,
		out
	)
	run_in_term({ "sh", "-c", cmd }, dir)
end

vim.api.nvim_create_user_command("GoRun", function(opts)
	local cmd = { "go", "run", "." }
	vim.list_extend(cmd, opts.fargs)
	run_in_term(cmd, pkg_dir())
end, { nargs = "*", desc = "go run current package" })

vim.api.nvim_create_user_command("GoModTidy", function()
	local root = vim.fs.root(0, { "go.mod" }) or vim.fn.getcwd()
	vim.system({ "go", "mod", "tidy" }, { cwd = root }, function(res)
		vim.schedule(function()
			if res.code == 0 then
				vim.notify("go mod tidy: done")
				vim.cmd("checktime")
			else
				vim.notify("go mod tidy failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
			end
		end)
	end)
end, { desc = "go mod tidy" })

return M
