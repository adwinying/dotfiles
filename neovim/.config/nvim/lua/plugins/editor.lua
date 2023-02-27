return {
  -- comments
  {
    "tpope/vim-commentary",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "tpope/vim-repeat" },
  },

  -- surround motions
  {
    "tpope/vim-surround",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "tpope/vim-repeat" },
  },

  -- advanced substitution
  {
    "tpope/vim-abolish",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "tpope/vim-repeat" },
  },

  -- . support for plugins
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },

  -- align blocks of text
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = { "x", "n" }, noremap = false },
    },
  },

  -- better % support
  {
    "andymass/vim-matchup",
    event = "BufReadPre",
    config = function()
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  -- auto insert matching brackets
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = {},
  },

  -- better escape
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = {
      -- a table with mappings to use
      mappings = { "jk" },
      -- the time in which the keys must be hit in ms
      timeout = vim.o.timeoutlen,
      -- clear line after escaping if there is only whitespace
      clear_empty_lines = true,
      -- keys used for escaping, if it is a function will use the result everytime
      -- example
      -- keys = function()
      --   return vim.fn.col '.' - 2 >= 1 and '<esc>l' or '<esc>'
      -- end,
      keys = "<Esc>",
    },
  },

  -- github copilot
  {
    "github/copilot.vim",
    event = "VeryLazy",
  },
}
