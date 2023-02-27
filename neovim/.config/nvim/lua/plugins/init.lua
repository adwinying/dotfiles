return {

  -- status bar
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function() require("configs.statusline") end,
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
      { "<leader>ff", "<CMD>Telescope find_files <CR>", desc = "Find Files" },
      { "<leader>fa", "<CMD>Telescope find_files hidden=true <CR>", desc = "Find Files (+ hidden)" },
      { "<leader>fb", "<CMD>Telescope buffers <CR>", desc = "Find Buffers" },
      { "<leader>fh", "<CMD>Telescope help_tags <CR>", desc = "Find Help Tags" },
      { "<leader>fw", "<CMD>Telescope live_grep <CR>", desc = "Grep" },
      { "<leader>fz", "<CMD>Telescope grep_string <CR>", desc = "Word" },
      { "<leader>fgc", "<CMD>Telescope git_bcommits <CR>", desc = "Find Git Commits" },
      { "<leader>fgs", "<CMD>Telescope git_status <CR>", desc = "Find Git Status" },
      { "<leader>f:", "<CMD>Telescope command_history <CR>", desc = "Find Command History" },
      { "<leader>fc", "<CMD>Telescope commands <CR>", desc = "Find Commands" },
      { "<leader>fm", "<CMD>Telescope media_files <CR>", desc = "Find Media Files" },
      { "<leader>fr", "<CMD>Telescope resume <CR>", desc = "Resume" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-media-files.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function () require("configs.telescope") end,
  },
}
