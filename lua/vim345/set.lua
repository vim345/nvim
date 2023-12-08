-- Enable relative number
vim.opt.nu = true
vim.opt.relativenumber = true

-- Format JSON.
-- vim.com! FormatJSON %!jq .
-- vim.com! FormatJSON4 %!python -m json.tool

-- Add automatic indent support.
-- filetype plugin indent on
vim.opt.showcmd = true         -- Show (partial) command in status line.
vim.opt.showmatch = true       -- Show matching brackets.
vim.opt.smartcase = true       -- Do smart case matching
vim.opt.incsearch = true       -- Incremental search
vim.opt.autowrite = true       -- Automatically save before commands like :next and :make
vim.opt.hidden = true          -- Hide buffers when they are abandoned
vim.opt.mouse=r         -- Disable mouse usage (all modes)
vim.opt.ruler = true           -- Add ruler to status bar.
vim.opt.tabpagemax=30   -- Max number of open tabs.

vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.api.nvim_create_autocmd("FileType", {
	pattern = "html",
	command = "setlocal ts=2 sw=2 sts=0"
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "css",
	command = "setlocal ts=2 sw=2 sts=0"
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	command = "setlocal ts=2 sw=2 sts=0"
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml",
	command = "setlocal ts=2 sw=2 sts=0"
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "javascript",
	command = "setlocal ts=2 sw=2 sts=0"
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	command = "setlocal ts=2 sw=2 sts=0"
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
vim.opt.pastetoggle = "<F9>"
