-- Install packer if does not exist
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local present
local packer

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path
  }

  vim.cmd "packadd packer.nvim"

  present, packer = pcall(require, "packer")

  if present then
    print "Packer cloned successfully."
  else
    error(string.format(
      "Couldn't clone packer!\nPacker path: %s\n%s",
      install_path,
      packer
    ))

    return
  end
end


-- Regenerate compiled loader file on file save
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])


-- load plugins
packer = packer or require("packer")

return packer.startup(function (use)
  -- yo dawg, I heard you like plugin managers
  use {
    "wbthomason/packer.nvim",
    event = "VimEnter",
    setup = function() require("mappings.packer") end,
  }

  -- -- colorscheme
  use {
    "arcticicestudio/nord-vim",
    after = "packer.nvim",
    config = function() require("configs.colors") end,
  }

  -- status bar
  use {
    "shadmansaleh/lualine.nvim",
    after = "packer.nvim",
    config = function() require("configs.statusline") end,
  }

  -- Preview colors of hexcodes
  use {
    "norcalli/nvim-colorizer.lua",
    event = "BufRead",
    config = function () require("colorizer").setup() end,
  }

  -- Better syntax highlighting
  use {
    "nvim-treesitter/nvim-treesitter",
    branch = "0.5-compat",
    run = ":TSUpdate",
    event = "BufRead",
    config = function () require("configs.treesitter") end,
  }

  -- Git signs
  use {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function () require("configs.gitsigns") end,
    setup = function () require("helpers").packer_lazy_load("gitsigns.nvim") end,
  }

  -- . support for plugins
  use {
    "tpope/vim-repeat",
    event = "BufRead",
  }

  -- comments
  use {
    "tpope/vim-commentary",
    after = "vim-repeat",
  }

  -- surround motions
  use {
    "tpope/vim-surround",
    after = "vim-repeat",
  }

  -- align blocks of text
  use {
    "junegunn/vim-easy-align",
    event = "BufRead",
    setup = function () require("mappings.align") end,
  }

  -- better % support
  use {
    "andymass/vim-matchup",
    setup = function() require("helpers").packer_lazy_load("vim-matchup") end,
    config = function() require("configs.matchup") end,
  }

  -- better escape
  use {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function() require("configs.better_escape") end,
  }

  -- completions
  use {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function () require("configs.cmp") end,
  }
  use {
    "hrsh7th/cmp-nvim-lsp",
    module = "cmp_nvim_lsp",
    after = "nvim-cmp",
  }
  use {
    "hrsh7th/cmp-buffer",
    after = "nvim-cmp",
  }
  use {
    "hrsh7th/cmp-path",
    after = "nvim-cmp",
  }
  use {
    "hrsh7th/cmp-nvim-lua",
    after = "nvim-cmp",
  }

  -- LSP config
  use {
    "neovim/nvim-lspconfig",
    requires = { "kabouzeid/nvim-lspinstall", },
    after = "cmp-nvim-lsp",
    setup = function() require("helpers").packer_lazy_load("nvim-lspconfig") end,
    config = function () require("configs.lspconfig") end,
  }

  -- show function signature
  use {
    "ray-x/lsp_signature.nvim",
    after = "nvim-lspconfig",
    config = function () require("configs.lsp_signature") end,
  }

  -- file finder
  use {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    requires = {
      {
        "nvim-lua/plenary.nvim",
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
      },
      {
        "nvim-telescope/telescope-media-files.nvim",
        setup = function () require("mappings.telescope_media") end,
      },
    },
    config = function () require("configs.telescope") end,
    setup = function () require("mappings.telescope") end,
  }
end)
