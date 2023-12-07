--vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
return {
  {
    "mbbill/undotree",
    keys = {
      {
        "<leader>u",
        "<cmd>UndotreeToggle<CR>",
        desc = "Show/Hide the undo window",
      },
    }
  }
}
