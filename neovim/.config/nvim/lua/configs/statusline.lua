local colors = require("colors")
local present, lualine = pcall(require, "lualine")

if not present then return end

lualine.setup {
  options = {
    icons_enabled = false,
    theme = "nord",
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
  },

  sections = {
    lualine_a = {"mode"},
    lualine_b = {
      {
        "branch",
        fmt = function (str)
          return str:len() >= 15 and str:sub(0, 12) .. "..." or str
        end,
      },
      {
        "diff",
        colored = true,
        -- all colors are in format #rrggbb
        diff_color = {
          added    = { fg = colors.green },
          modified = { fg = colors.yellow },
          removed  = { fg = colors.red },
        },
        symbols = {added = "+", modified = "~", removed = "-"},
      },
    },
    lualine_c = {
      "filename",
      {
        "diagnostics",
        -- table of diagnostic sources, available sources:
        -- nvim_diagnostic, coc, ale, vim_lsp
        sources = {"nvim_diagnostic"},
        -- displays diagnostics from defined severity
        sections = {"error", "warn", "info", "hint"},
        -- all colors are in format #rrggbb
        diagnostics_color = {
          error = { fg = colors.red },
          warn  = { fg = colors.yellow },
          info  = { fg = colors.orange },
          hint  = { fg = colors.lightblue },
        },
        symbols = {error = "E", warn = "W", info = "I", hint = "H"},
      },
    },
    lualine_x = {"encoding", "fileformat", "filetype"},
    lualine_y = {"progress"},
    lualine_z = {"location"},
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {"filename"},
    lualine_x = {"location"},
    lualine_y = {},
    lualine_z = {},
  },

  tabline = {
    lualine_a = {
      {
        "tabs",
        -- maximum width of tabs component
        max_length = vim.o.columns,
        -- 0  shows tab_nr
        -- 1  shows tab_name
        -- 2  shows tab_nr + tab_name
        mode = 2,
        tabs_color = {
          active   = { bg = colors.lightblue },
          inactive = { bg = colors.darkblue , fg = colors.white},
        },
      },
    },
  },

  extensions = {},
}
