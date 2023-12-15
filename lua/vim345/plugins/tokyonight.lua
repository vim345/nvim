return {
	"folke/tokyonight.nvim",
	priority = 1000,
	-- lazy = false,
	config = function()
		local tokyonight = require("tokyonight")
		tokyonight.setup({
			styles = {
				-- Style to be applied to different syntax groups
				-- Value is any valid attr-list value for `:help nvim_set_hl`
				comments = { italic = true },
				keywords = { italic = true },
				functions = {},
				variables = {},
				-- Background styles. Can be "dark", "transparent" or "normal"
				sidebars = "dark", -- style for sidebars, see below
				floats = "dark", -- style for floating windows
			},
			dim_inactive = true,
			lualine_bold = true,
			on_colors = function(colors)
				colors.comment = "#d48f8a"
				colors.fg_gutter = "#b3635d"
			end,
		})

		-- This has to come after all the configs.
		vim.cmd.colorscheme("tokyonight-moon")
	end,
}
