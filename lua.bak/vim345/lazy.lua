local default_plugins = {
  {
      'nvim-telescope/telescope.nvim', tag = '0.1.5',
      -- or                            , branch = '0.1.x',
      dependencies = { {'nvim-lua/plenary.nvim'} }
  },
  {
      "NvChad/nvim-colorizer.lua",
      init = function()
              require("core.utils").lazy_load "nvim-colorizer.lua"
      end,
      config = function(_, opts)
              require("colorizer").setup(opts)

              -- execute colorizer as soon as possible
              vim.defer_fn(function()
            	  require("colorizer").attach_to_buffer(0)
              end, 0)
      end,
  },

  {
      'nvim-treesitter/nvim-treesitter',
      build = function()
          local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
          ts_update()
  end,},
  {"nvim-treesitter/playground"},
  {"mbbill/undotree"},
  {"tpope/vim-fugitive"},
  {"nvim-treesitter/nvim-treesitter-context"},
  {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v1.x',
      dependencies = {
          -- LSP Support
          {'neovim/nvim-lspconfig'},
          {'williamboman/mason.nvim'},
          {'williamboman/mason-lspconfig.nvim'},

          -- Autocompletion
          {'hrsh7th/nvim-cmp'},
          {'hrsh7th/cmp-buffer'},
          {'hrsh7th/cmp-path'},
          {'saadparwaiz1/cmp_luasnip'},
          {'hrsh7th/cmp-nvim-lsp'},
          {'hrsh7th/cmp-nvim-lua'},

          -- Snippets
          {'L3MON4D3/LuaSnip'},
          {'rafamadriz/friendly-snippets'},
      }
  }
}
