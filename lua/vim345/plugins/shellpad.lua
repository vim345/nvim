return {
	"shellpad/shellpad.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	config = function(opts)
		require("shellpad").setup(opts)
		vim.keymap.set(
			"n",
			"<leader>fss",
			require("shellpad").telescope_history_search(),
			{ desc = "[S]earch shell [C]ommands" }
		)
	end,
}
