local present, ts_config = pcall(require, "nvim-treesitter.configs")

if not present then return end

ts_config.setup {
  ensure_installed = {
    "lua",
    "vim",

    "html",
    "javascript",
    "typescript",
    "tsx",
    "svelte",

    "dart",
    "php",
    "go",
    "gomod",
  },

  highlight = {
    enable = true,
  },
}
