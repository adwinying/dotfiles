local colors = require("colors")
local present, lualine = pcall(require, "lualine")

if not present then return end

lualine.setup {
  options = {
    icons_enabled = false,
    theme = "nord",
    component_separators = "|",
    section_separators = "",
    disabled_filetypes = {}
  },

  sections = {
    lualine_a = {"mode"},
    lualine_b = {
      "branch",
      {
        "diff",
        colored = true,
        -- all colors are in format #rrggbb
        color_added = colors.green,
        color_modified = colors.yellow,
        color_removed = colors.red,
        symbols = {added = "+", modified = "~", removed = "-"}
      }
    },
    lualine_c = {
      "filename",
      {
        "diagnostics",
        -- table of diagnostic sources, available sources:
        -- nvim_lsp, coc, ale, vim_lsp
        sources = {"nvim_lsp"},
        -- displays diagnostics from defined severity
        sections = {"error", "warn", "info", "hint"},
        -- all colors are in format #rrggbb
        color_error = colors.red,
        color_warn = colors.yellow,
        color_info = colors.orange,
        color_hint = colors.lightblue,
        symbols = {error = "E", warn = "W", info = "I", hint = "H"},
      },
    },
    lualine_x = {"encoding", "fileformat", "filetype"},
    lualine_y = {"progress"},
    lualine_z = {"location"}
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {"filename"},
    lualine_x = {"location"},
    lualine_y = {},
    lualine_z = {}
  },

  tabline = {},

  extensions = {},
}
