return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "truncate " },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local builtin = require("telescope.builtin")
		local keymap = vim.keymap -- for conciseness

		-- load refactoring Telescope extension
		require("telescope").load_extension("refactoring")

		keymap.set("n", "<F4>", builtin.buffers, { desc = "Fuzzy find open buffers" })
		keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
		keymap.set(
			"n",
			"<leader>fg",
			builtin.git_files,
			{ desc = "Fuzzy search through the output of git ls-files command, respects .gitignore" }
		)
		keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
		keymap.set(
			"n",
			"<leader>fq",
			builtin.resume,
			{ desc = "Lists the results incl. multi-selections of the previous picker" }
		)
		keymap.set(
			"n",
			"<leader>fh",
			builtin.command_history,
			{ desc = "Lists commands that were executed recently, and reruns them on <cr>" }
		)
		keymap.set(
			"n",
			"<leader>fhs",
			builtin.search_history,
			{ desc = "Lists searches that were executed recently, and reruns them on <cr>" }
		)
		keymap.set(
			"n",
			"<leader>fsb",
			builtin.current_buffer_fuzzy_find,
			{ desc = "Live fuzzy search inside of the currently open buffer" }
		)
		keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
		keymap.set(
			"n",
			"<leader>fci",
			builtin.git_commits,
			{ desc = "Lists commits for current directory with diff preview" }
		)
		keymap.set(
			"n",
			"<leader>fbc",
			builtin.git_bcommits,
			{ desc = "Lists commits for current buffer with diff preview" }
		)

		keymap.set({ "n", "x" }, "<leader>rr", function()
			require("telescope").extensions.refactoring.refactors()
		end)
	end,
}
