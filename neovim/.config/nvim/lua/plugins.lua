-- Install lazy if does not exist
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load plugins
require('lazy').setup({
  -- colorscheme
  {
    "arcticicestudio/nord-vim",
    lazy = false,
    prioriy = 1000,
    config = function() require("configs.colors") end,
  },

  -- status bar
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function() require("configs.statusline") end,
  },

  -- Preview colors of hexcodes
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function () require("configs.colorizer") end,
  },

  -- Better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function () require("configs.treesitter") end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function () require("configs.gitsigns") end,
  },

  -- . support for plugins
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
    dependencies = {
      -- comments
      "tpope/vim-commentary",
      -- surround motions
      "tpope/vim-surround",
      -- advanced substitution
      "tpope/vim-abolish",
    }
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
    config = function() require("configs.matchup") end,
  },

  -- better escape
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function() require("configs.better_escape") end,
  },

  -- smooth scrolling
  {
    "terryma/vim-smooth-scroll",
    keys = {
      { "<C-U>", function() vim.api.nvim_command("call smooth_scroll#up(&scroll, 0, 4)") end },
      { "<C-D>", function() vim.api.nvim_command("call smooth_scroll#down(&scroll, 0, 4)") end },
      { "<C-B>", function() vim.api.nvim_command("call smooth_scroll#up(&scroll*2, 0, 4)") end },
      { "<C-F>", function() vim.api.nvim_command("call smooth_scroll#down(&scroll*2, 0, 4)") end },
    },
  },

  -- tmux integration
  {
    "aserowy/tmux.nvim",
    event = "VeryLazy",
    config = function() require("configs.tmux") end,
  },

  -- OSC52 (universal clipboard) integration
  {
    "ojroques/vim-oscyank",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("configs.oscyank") end,
  },

  -- LSP
  {
    'VonHeikemen/lsp-zero.nvim',
    event = { "BufReadPre", "BufNewFile" },
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
      {'hrsh7th/cmp-nvim-lsp-signature-help'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    },
    config = function() require("configs.lspzero") end,
  },

  -- auto insert matching brackets
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function () require("configs.autopairs") end,
  },

  -- keybindings at a glance
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function () require("configs.whichkey") end,
  },

  -- github copilot
  {
    "github/copilot.vim",
    event = "VeryLazy",
  },

  -- file finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    keys = {
      { "<leader>ff", ":Telescope find_files <CR>", desc = "Find Files" },
      { "<leader>fa", ":Telescope find_files hidden=true <CR>", desc = "Find Files (+ hidden)" },
      { "<leader>fb", ":Telescope buffers <CR>", desc = "Find Buffers" },
      { "<leader>fh", ":Telescope help_tags <CR>", desc = "Find Help Tags" },
      { "<leader>fw", ":Telescope live_grep <CR>", desc = "Grep" },
      { "<leader>fz", ":Telescope grep_string <CR>", desc = "Word" },
      { "<leader>fgc", ":Telescope git_bcommits <CR>", desc = "Find Git Commits" },
      { "<leader>fgs", ":Telescope git_status <CR>", desc = "Find Git Status" },
      { "<leader>f:", ":Telescope command_history <CR>", desc = "Find Command History" },
      { "<leader>fc", ":Telescope commands <CR>", desc = "Find Commands" },
      { "<leader>fm", ":Telescope media_files <CR>", desc = "Find Media Files" },
      { "<leader>fr", ":Telescope resume <CR>", desc = "Resume" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-media-files.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function () require("configs.telescope") end,
  },
})

vim.keymap.set("n", "<leader>la", "<CMD>:Lazy<CR>", { noremap = true, silent = true, desc = "Lazy" })
