-- Enable relative number
vim.opt.nu = true
vim.opt.relativenumber = true

-- Format JSON.
-- vim.com! FormatJSON %!jq .
-- vim.com! FormatJSON4 %!python -m json.tool

-- Add automatic indent support.
-- filetype plugin indent on
vim.opt.showcmd = true -- Show (partial) command in status line.
vim.opt.showmatch = true -- Show matching brackets.
vim.opt.smartcase = true -- Do smart case matching
vim.opt.incsearch = true -- Incremental search
vim.opt.autowrite = true -- Automatically save before commands like :next and :make
vim.opt.hidden = true -- Hide buffers when they are abandoned
vim.opt.mouse = "r" -- Disable mouse usage (all modes)
vim.opt.ruler = true -- Add ruler to status bar.
vim.opt.tabpagemax = 30 -- Max number of open tabs.

vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.api.nvim_create_autocmd("FileType", {
	pattern = "html",
	command = "setlocal ts=2 sw=2 sts=0",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "css",
	command = "setlocal ts=2 sw=2 sts=0",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	command = "setlocal ts=2 sw=2 sts=0",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml",
	command = "setlocal ts=2 sw=2 sts=0",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "javascript",
	command = "setlocal ts=2 sw=2 sts=0",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	command = "setlocal ts=2 sw=2 sts=0",
})

-- Highlight search matches.
vim.opt.hlsearch = true

-- Make diff split vertical
vim.opt.diffopt = "vertical"

-- Make the new vertical open on the right side
vim.opt.splitright = true

-- Vim's popup menu doesn't select the first completion item. Also don't show
-- the top bar.
vim.opt.completeopt = "longest,menuone"

-- Let backspace do its job
vim.opt.backspace = "indent,eol,start"

-- Toggle Paste Mode
-- vim.opt.pastetoggle = "<F9>"

-- Jump to the last position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		local ft = vim.opt_local.filetype:get()
		-- don't apply to git messages
		if ft:match("commit") or ft:match("rebase") then
			return
		end
		-- get position of last saved edit
		local markpos = vim.api.nvim_buf_get_mark(0, '"')
		local line = markpos[1]
		local col = markpos[2]
		-- if in range, go there
		if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
			vim.api.nvim_win_set_cursor(0, { line, col })
		end
	end,
})

-- Set the python virtualenv based on the current directory
local function get_env(env)
	local venv_path = vim.fn.finddir(env, ".;")
	if venv_path ~= "" then
		vim.g.python3_host_prog = venv_path .. "/bin/python3"
		return true
	end
	return false
end

local function set_python_host_prog()
	local envs = { "venv", "virtualenv_run" }

	for _, env in ipairs(envs) do
		if get_env(env) then
			break
		end
	end
end

set_python_host_prog()

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.java",
	command = "!./gradlew spotlessApply > /dev/null",
})
