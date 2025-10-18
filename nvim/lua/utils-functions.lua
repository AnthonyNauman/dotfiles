local function get_workbench()
	return "~/workbench/"
end

local function get_startup_path()
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

	return get_workbench()
end

local function get_curr_file_folder_path()
	local current_file = vim.fn.expand("%:p")
	return vim.fn.fnamemodify(current_file, ":h")
end

local function get_curr_file_path()
	local current_file = vim.fn.expand("%:p")
	return string.format("%s", current_file)
end
