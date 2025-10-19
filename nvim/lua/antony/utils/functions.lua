local M = {}

function M.printHello()
	print("Hello from utils.functions")
end

function M.get_workbench()
	return "~/workbench/"
end

function M.get_startup_path()
	local args = vim.v.argv
	local processed_args = {}

	for i = 2, #args do
		local arg = args[i]
		if not arg:match("^-") then
			table.insert(processed_args, arg)
		end
	end

	if #processed_args > 0 then
		local path = vim.fn.expand(processed_args[1])
		if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
			return vim.fn.fnamemodify(path, ":p:h")
		end
	end

	return M.get_workbench()
end

function M.get_current_buffer_path()
	local bufname = vim.fn.bufname()
	local pattern = "oil://"
	if bufname:match(pattern) then
		local cur_file = string.gsub(bufname, pattern, "")
		print(cur_file)
		return cur_file
	end

	local file = vim.fn.expand("%:p")
	print(file)
	return vim.fn.fnamemodify(file, ":h")
end

function M.get_curr_file_folder_path()
	local bufname = vim.fn.bufname()
	if bufname == "" or vim.fn.isdirectory(bufname) == 1 then
		local cwd = vim.fn.getcwd()
		return cwd
	else
		local current_file = vim.fn.expand("%:p")
		local fname = vim.fn.fnamemodify(current_file, ":h")
		return fname
	end
end

function M.get_curr_file_path()
	local current_file = vim.fn.expand("%:p")
	return string.format("%s", current_file)
end

return M
