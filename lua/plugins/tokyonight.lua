return {
  "folke/tokyonight.nvim",
  opts = { style = "moon" },
  lazy = false,
  config = function()
    vim.cmd.colorscheme "tokyonight"
  end,
}
