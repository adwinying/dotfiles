local present, ts_config = pcall(require, "nvim-treesitter.configs")

if not present then return end

-- Automatically set syntax for astro files
vim.cmd "autocmd BufRead,BufEnter *.astro set filetype=astro"

ts_config.setup {
  ensure_installed = {
    "lua",
    "vim",

    "html",
    "javascript",
    "typescript",
    "tsx",
    "svelte",
    "astro",
    "prisma",
    "graphql",

    "dart",
    "php",
    "go",
    "gomod",
  },

  highlight = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection    = "gnn",
      node_incremental  = "grn",
      scope_incremental = "grc",
      node_decremental  = "grm",
    },
  },

  indent = {
    enable = true,
  },
}
