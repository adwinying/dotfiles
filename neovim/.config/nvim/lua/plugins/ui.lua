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

      on_attach    = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Navigation
        map('n', ']c', gs.next_hunk, 'Next Hunk')
        map('n', '[c', gs.prev_hunk, 'Prev Hunk')

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, 'Stage Hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Reset Hunk')
        map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, 'Stage Hunk')
        map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, 'Reset Hunk')
        map('n', '<leader>hS', gs.stage_buffer, 'Stage Buffer')
        map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo Stage Hunk')
        map('n', '<leader>hR', gs.reset_buffer, 'Reset Buffer')
        map('n', '<leader>hp', gs.preview_hunk, 'Preview Hunk')
        map('n', '<leader>hb', function() gs.blame_line{full=true} end, 'Blame Line')
        map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle Blame')
        map('n', '<leader>hd', gs.diffthis, 'Diff This')
        map('n', '<leader>hD', function() gs.diffthis('~') end, 'Diff This ~')
        map('n', '<leader>td', gs.toggle_deleted, 'Toggle Deleted')

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select Hunk')
      end,

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
