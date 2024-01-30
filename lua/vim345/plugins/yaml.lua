return {
	"cuducos/yaml.nvim",
	ft = { "yaml" }, -- optional
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = function()
		local yaml = require("yaml_nvim")
		yaml.setup({
			autoformat = false,
		})
	end,
}
