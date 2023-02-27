local colors = require("colors")

return {
  -- status bar
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = false,
        theme = "nord",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
      },

      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          {
            "branch",
            fmt = function(str)
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
            symbols = { added = "+", modified = "~", removed = "-" },
          },
        },
        lualine_c = {
          "filename",
          {
            "diagnostics",
            -- table of diagnostic sources, available sources:
            -- nvim_diagnostic, coc, ale, vim_lsp
            sources = { "nvim_diagnostic" },
            -- displays diagnostics from defined severity
            sections = { "error", "warn", "info", "hint" },
            -- all colors are in format #rrggbb
            diagnostics_color = {
              error = { fg = colors.red },
              warn  = { fg = colors.yellow },
              info  = { fg = colors.orange },
              hint  = { fg = colors.lightblue },
            },
            symbols = { error = "E", warn = "W", info = "I", hint = "H" },
          },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
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
              inactive = { bg = colors.darkblue, fg = colors.white },
            },
          },
        },
      },

      extensions = {},
    },
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs        = {
        add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      },

      signcolumn   = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl        = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl       = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff    = false, -- Toggle with `:Gitsigns toggle_word_diff`

      keymaps      = {
        -- Default keymap options
        noremap = true,

        ["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
        ["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },

        ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        ["v <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
        ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ["v <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
        ["n <leader>hR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
        ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
        ["n <leader>hS"] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
        ["n <leader>hU"] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',

        -- Text objects
        ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
        ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
      },

      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
    },
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

  -- keybindings at a glance
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
