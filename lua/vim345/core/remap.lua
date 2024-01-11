-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

-- Maping shortcut keys to tab switching
vim.keymap.set("n", "<C-l>", ":tabnext<CR>", { silent = true })
vim.keymap.set("n", "<C-h>", ":tabprevious<CR>", { silent = true })

-- Erasing trailing whitespace
-- vim.keymap.set("n", "<leader>e", "\:\%s/\s\+$//<CR>")

-- Clean highlights with Ctrl+n
vim.keymap.set("n", "<C-N>", ":silent noh<CR>", { silent = true })

-- Mappings for diff
vim.keymap.set("n", "<leader>d", ":windo diffthis<CR>")
vim.keymap.set("n", "<leader>o", ":windo diffoff<CR>")
