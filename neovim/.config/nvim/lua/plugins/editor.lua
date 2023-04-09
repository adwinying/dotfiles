return {
  -- advanced substitution
  {
    "tpope/vim-abolish",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- comments
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "echasnovski/mini.comment",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      hooks = {
        pre = function()
          require("ts_context_commentstring.internal").update_commentstring({})
        end,
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },

  -- surround motions
  {
    "echasnovski/mini.surround",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      mappings = {
        add = 'ys',
        delete = 'ds',
        find = '',
        find_left = '',
        highlight = '',
        replace = 'cs',
        update_n_lines = '',

        -- Add this only if you don't want to use extended mappings
        suffix_last = '',
        suffix_next = '',
      },
      search_method = 'cover_or_next',
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
      vim.keymap.set('n', 'yss', 'ys_', { remap = true })
    end,
  },

  -- align blocks of text
  {
    "echasnovski/mini.align",
    event = { "BufReadPost", "BufNewFile" },
    config = function(_, opts)
      require("mini.align").setup(opts)
    end,
  },

  -- auto insert matching brackets
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
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

  -- better escape
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
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
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",
        },
      },
    }
  },

  -- search/replace in multiple files
  {
    "windwp/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>fs", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },
}
