return {
  {
      'nvim-telescope/telescope.nvim', tag = '0.1.5',
      dependencies = { {'nvim-lua/plenary.nvim'} },
      keys = {
          {
            "<C-p>",
            "<cmd>Telescope find_files<cr>",
            desc = "Find all files",
          },
          {
            "<C-g>",
            "<cmd>Telescope git_files<cr>",
            desc = "Find git files",
          },
      },
  },
}
