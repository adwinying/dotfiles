local colors = require("colors")

return {
  -- Nord theme
  {
    "arcticicestudio/nord-vim",
    lazy = false,
    priority = 1000,
    config = function()
      -- disable bg color
      vim.cmd("highlight Normal guibg=NONE")
      vim.cmd("highlight SignColumn guibg=NONE")
      vim.cmd("highlight VertSplit guibg=NONE")

      -- LSP color highlight
      vim.cmd("highlight DiagnosticError guifg=" .. colors.red)
      vim.cmd("highlight DiagnosticWarn guifg=" .. colors.yellow)
      vim.cmd("highlight DiagnosticInfo guifg=" .. colors.lightblue)
      vim.cmd("highlight DiagnosticHint guifg=" .. colors.cyan)
    end,
  },

  -- Preview colors of hexcodes
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = true, -- "Name" codes like Blue or blue
          RRGGBBAA = false, -- #RRGGBBAA hex codes
          AARRGGBB = false, -- 0xAARRGGBB hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = "background", -- Set the display mode.
          -- Available methods are false / true / "normal" / "lsp" / "both"
          -- True is same as normal
          tailwind = "both", -- Enable tailwind colors
          -- parsers can contain values used in |user_default_options|
          sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
          virtualtext = "■",
        },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = {},
      })

      vim.cmd("ColorizerReloadAllBuffers")
    end,
  },
}
