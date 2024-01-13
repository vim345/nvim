return {
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
			vim.keymap.set("n", "<localleader>c", "<cmd>GoCoverage<CR>")
			vim.keymap.set("n", "<localleader>tt", "<cmd>GoTest<CR>")
			vim.keymap.set("n", "<localleader>tf", "<cmd>GoTestFunc<CR>")
			vim.keymap.set("n", "<localleader>aa", "<cmd>GoAlt<CR>")
			vim.keymap.set("n", "<localleader>av", "<cmd>GoAltV<CR>")
			vim.keymap.set("n", "<localleader>as", "<cmd>GoAltS<CR>")
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
}
