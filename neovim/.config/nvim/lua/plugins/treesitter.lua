return {
  -- Better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua",
        "vim",

        "html",
        "javascript",
        "typescript",
        "tsx",
        "vue",
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
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Automatically set syntax for astro files
      vim.cmd "autocmd BufRead,BufEnter *.astro set filetype=astro"
    end,
  },
}
