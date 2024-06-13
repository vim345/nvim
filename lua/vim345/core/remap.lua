local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }
-- Maping shortcut keys to tab switching
keymap.set("n", "<C-l>", ":tabnext<CR>", { silent = true })
keymap.set("n", "<C-h>", ":tabprevious<CR>", { silent = true })

-- Erasing trailing whitespace
-- vim.keymap.set("n", "<leader>e", "\:\%s/\s\+$//<CR>")

-- Clean highlights with Ctrl+n
keymap.set("n", "<C-N>", ":silent noh<CR>", { silent = true })

-- Mappings for diff
keymap.set("n", "<leader>d", ":windo diffthis<CR>")
keymap.set("n", "<leader>o", ":windo diffoff<CR>")

-- vim.cmd("abbrev pdb import pdb;")

-- Open the corresnponding -pnw file
function regions(vertical_split)
	-- Get the current file name
	local current_file = vim.fn.expand("%:t")
	local new_file

	-- Check if the current file contains -nova or -pnw and toggle
	if current_file:find("-nova") then
		new_file = current_file:gsub("-nova", "-pnw")
	elseif current_file:find("-pnw") then
		new_file = current_file:gsub("-pnw", "-nova")
	else
		print("Current file does not contain -nova or -pnw")
		return
	end

	-- Construct the full path
	local full_path = vim.fn.expand("%:p:h") .. "/" .. new_file

	-- Open the new file, optionally in a vertical split
	if vertical_split then
		vim.cmd("vsplit " .. full_path)
	else
		vim.cmd("edit " .. full_path)
	end
end

-- Map the function to a shortcut key, e.g., <Leader>p
vim.api.nvim_set_keymap("n", "<\t>", ":lua toggle_regions(false)<CR>", { noremap = true, silent = true })

function toggle_related(vertical_split)
	-- Get the current file name and parent directory
	local current_file = vim.fn.expand("%:t")
	local current_dir = vim.fn.expand("%:p:h:t")
	local filetype = vim.bo.filetype
	local new_file, new_dir

	-- Check if the filetype is java and toggle between source and test files
	if filetype == "java" then
		local buffer_path = vim.fn.expand("%:p")
		local src_index = buffer_path:find("/src/")
		if src_index then
			local base_dir = buffer_path:sub(1, src_index + 4) -- Get the base directory up to /src/
			if buffer_path:find("/main/java/") then
				new_dir = buffer_path:gsub("/main/java/", "/test/java/")
				new_file = current_file:gsub("%.java$", "Test.java")
			elseif buffer_path:find("/test/java/") then
				new_dir = buffer_path:gsub("/test/java/", "/main/java/")
				new_file = current_file:gsub("Test%.java$", ".java")
			else
				print("Current Java file is not in a recognized source or test directory")
				return
			end
			full_path = new_dir:gsub(current_file, new_file)
		else
			print("Current Java file is not in a recognized src directory")
			return
		end
	else
		-- Check if the current file contains -nova or -pnw and toggle
		if current_file:find("-nova") then
			new_file = current_file:gsub("-nova", "-pnw")
			new_dir = vim.fn.expand("%:p:h")
		elseif current_file:find("-pnw") then
			new_file = current_file:gsub("-pnw", "-nova")
			new_dir = vim.fn.expand("%:p:h")
		else
			if current_file:find("-nova") then
				new_file = current_file:gsub("-nova", "-pnw")
				new_dir = vim.fn.expand("%:p:h")
			elseif current_file:find("-pnw") then
				new_file = current_file:gsub("-pnw", "-nova")
				new_dir = vim.fn.expand("%:p:h")
			else
				-- If the file name doesn't contain -nova or -pnw, toggle the parent directory
				if current_dir == "nova-prod" then
					new_dir = vim.fn.expand("%:p:h:h") .. "/pnw-prod"
				elseif current_dir == "pnw-prod" then
					new_dir = vim.fn.expand("%:p:h:h") .. "/nova-prod"
				else
					print("Current file is not in nova-prod or pnw-prod directory, and does not contain -nova or -pnw")
					return
				end
				new_file = current_file
			end
		end
	end

	full_path = new_dir .. "/" .. new_file

	-- Open the new file, optionally in a vertical split
	if vertical_split then
		vim.cmd("vsplit " .. full_path)
	else
		vim.cmd("edit " .. full_path)
	end
end

opts.desc = "Open related file"
keymap.set("n", "<leader>", toggle_related, opts)

opts.desc = "Open related file in vertical split"
keymap.set("n", "<leader>rv", function()
	toggle_related(true)
end, opts)
