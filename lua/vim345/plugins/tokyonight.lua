return {
  "folke/tokyonight.nvim",
  priority = 1000,
  opts = { style = "moon" },
  lazy = false,
  config = function()
    vim.cmd.colorscheme "tokyonight"
  end,
}
