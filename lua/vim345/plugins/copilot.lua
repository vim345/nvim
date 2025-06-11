return {
	{ "github/copilot.vim" },
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = false, -- Enable debugging
			-- See Configuration section for rest
		},
		config = function()
			vim.api.nvim_set_keymap(
				"i",
				"<C-Space>",
				'copilot#Accept("<CR>")',
				{ noremap = true, silent = true, expr = true }
			)
		end,
		-- See Commands section for default commands if you want to lazy load on them
	},
}
