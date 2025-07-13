--
--  _  _ ___ _____   _____ __  __
-- | \| | __/ _ \ \ / /_ _|  \/  |
-- | .` | _| (_) \ V / | || |\/| |
-- |_|\_|___\___/ \_/ |___|_|  |_|
--

--
-- [[ Prerequisites ]]
--

-- source basic configs from vim
vim.cmd("source " .. vim.fn.stdpath("config") .. "/basic.vim")

--
-- [[ Utils ]]
--

-- Theme colors
local colors = {
  cyan      = "#8fbcbb",
  lightblue = "#88c0d0",
  darkblue  = "#2e3440",
  red       = "#bf616a",
  orange    = "#d08770",
  yellow    = "#ebcb8b",
  green     = "#a3be8c",
  white     = "#eceff4",
  black     = "#000000",
}

--
-- [[ Neovim-only config ]]
--

-- enable termguicolors
vim.opt.termguicolors = true

--
-- [[ Plugins ]]
--

-- Install lazy.nvim if does not exist
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load plugins
require("lazy").setup({
  --
  -- [[[ UI ]]]
  --
  -- Color scheme
  {
    "arcticicestudio/nord-vim",
    lazy = false,
    priority = 1000,
    config = function()
      -- disable bg color
      vim.cmd("highlight Normal guibg=NONE")
      vim.cmd("highlight NormalFloat guibg=NONE")
      vim.cmd("highlight SignColumn guibg=NONE")
      vim.cmd("highlight VertSplit guibg=NONE")

      -- LSP color highlight
      vim.cmd("highlight DiagnosticError guifg=" .. colors.red)
      vim.cmd("highlight DiagnosticWarn guifg=" .. colors.yellow)
      vim.cmd("highlight DiagnosticInfo guifg=" .. colors.lightblue)
      vim.cmd("highlight DiagnosticHint guifg=" .. colors.cyan)
    end,
  },

  -- Preview hexcode colors
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,          -- #RGB hex codes
          RRGGBB = true,       -- #RRGGBB hex codes
          names = true,        -- "Name" codes like Blue or blue
          RRGGBBAA = false,    -- #RRGGBBAA hex codes
          AARRGGBB = false,    -- 0xAARRGGBB hex codes
          rgb_fn = true,       -- CSS rgb() and rgba() functions
          hsl_fn = true,       -- CSS hsl() and hsla() functions
          css = true,          -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true,       -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = "background", -- Set the display mode.
          -- Available methods are false / true / "normal" / "lsp" / "both"
          -- True is same as normal
          tailwind = "both",                               -- Enable tailwind colors
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

  -- status bar
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = false,
        theme = "nord",
        component_separators = { left = "", right = "" },
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

  -- file explorer
  {
    'stevearc/oil.nvim',
    -- event = "VeryLazy",
    opts = {
      keymaps = {
        ["`"] = false,
        ["~"] = false,
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
    },
    setup = function(_, opts)
      require('oil').setup(opts)

      vim.keymap.set("n", "<leader>j", ":vsplit<CR>:e %:p:h<CR>", { desc = "Explore current dir" })
    end
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
    opts = {
      icons = {
        mappings = false,
      },
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

      signcolumn   = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl        = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl       = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff    = false, -- Toggle with `:Gitsigns toggle_word_diff`

      on_attach    = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Navigation
        map('n', ']h', gs.next_hunk, 'Next Hunk')
        map('n', '[h', gs.prev_hunk, 'Prev Hunk')

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, 'Stage Hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Reset Hunk')
        map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Stage Hunk')
        map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Reset Hunk')
        map('n', '<leader>hS', gs.stage_buffer, 'Stage Buffer')
        map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo Stage Hunk')
        map('n', '<leader>hR', gs.reset_buffer, 'Reset Buffer')
        map('n', '<leader>hp', gs.preview_hunk, 'Preview Hunk')
        map('n', '<leader>hb', function() gs.blame_line { full = true } end, 'Blame Line')
        map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle Blame')
        map('n', '<leader>hd', gs.diffthis, 'Diff This')
        map('n', '<leader>hD', function() gs.diffthis('~') end, 'Diff This ~')
        map('n', '<leader>td', gs.toggle_deleted, 'Toggle Deleted')

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select Hunk')
      end,

      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
    },
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    keys = {
      { "<leader>ff",  "<CMD>Telescope find_files <CR>",             desc = "Find Files" },
      { "<leader>fa",  "<CMD>Telescope find_files hidden=true <CR>", desc = "Find Files (+ hidden)" },
      { "<leader>fb",  "<CMD>Telescope buffers <CR>",                desc = "Find Buffers" },
      { "<leader>fh",  "<CMD>Telescope help_tags <CR>",              desc = "Find Help Tags" },
      { "<leader>fw",  "<CMD>Telescope live_grep <CR>",              desc = "Grep" },
      { "<leader>fz",  "<CMD>Telescope grep_string <CR>",            desc = "Word" },
      { "<leader>fgc", "<CMD>Telescope git_bcommits <CR>",           desc = "Find Git Commits" },
      { "<leader>fgs", "<CMD>Telescope git_status <CR>",             desc = "Find Git Status" },
      { "<leader>f:",  "<CMD>Telescope command_history <CR>",        desc = "Find Command History" },
      { "<leader>fc",  "<CMD>Telescope commands <CR>",               desc = "Find Commands" },
      { "<leader>fm",  "<CMD>Telescope media_files <CR>",            desc = "Find Media Files" },
      { "<leader>fr",  "<CMD>Telescope resume <CR>",                 desc = "Resume" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-media-files.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require('telescope')

      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,
            },
          },

          layout_config = {
            horizontal = {
              preview_width = 0.55,
              results_width = 0.8,
            },
            width = 0.85,
            height = 0.80,
            preview_cutoff = 120,
          },
        },

        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },

          media_files = {
            filetypes = { "png", "webp", "jpg", "jpeg" },
            find_cmd = "rg",
          },
        },

        pickers = {
          grep_string = {
            search = "",
            only_sort_text = false,
          },
        },
      }

      -- Load fzf extension
      telescope.load_extension("fzf")

      -- Load media_files extension if ueberzug exists
      if vim.fn.executable "ueberzug" == 1 then
        telescope.load_extension("media_files")
      end
    end,
  },

  -- search/replace in multiple files
  {
    "windwp/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      replace_engine = { sed = { cmd = "sed" } }
    },
    keys = {
      { "<leader>fs", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  --
  -- [[[ Editor ]]]
  --
  -- advanced substitution
  {
    "tpope/vim-abolish",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- comments
  {
    "echasnovski/mini.comment",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
          require('ts_context_commentstring').setup({
            enable_autocmd = false,
          })
        end,
      },
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('mini.comment').setup({
        options = {
          custom_commentstring = function()
            return require('ts_context_commentstring').calculate_commentstring()
                or vim.bo.commentstring
          end,
        },
      })
    end,
  },

  -- surround motions
  {
    "echasnovski/mini.surround",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      mappings = {
        add = 'ys',
        delete = 'ds',
        find = '',
        find_left = '',
        highlight = '',
        replace = 'cs',
        update_n_lines = '',

        -- Add this only if you don't want to use extended mappings
        suffix_last = '',
        suffix_next = '',
      },
      search_method = 'cover_or_next',
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
      vim.keymap.set('n', 'yss', 'ys_', { remap = true })
    end,
  },

  -- align blocks of text
  {
    "echasnovski/mini.align",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- auto insert matching brackets
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },

  -- better escape
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      -- a table with mappings to use
      mappings = {
        -- i for insert
        i = {
          j = {
            -- These can all also be functions
            k = "<Esc>",
            j = "<Esc>",
          },
        },
        c = {
          j = {
            k = "<C-c>",
            j = "<C-c>",
          },
        },
        t = {
          j = {
            k = "<C-\\><C-n>",
          },
        },
        v = {
          j = {
            k = "<Esc>",
          },
        },
        s = {
          j = {
            k = "<Esc>",
          },
        },
      },
      -- the time in which the keys must be hit in ms
      timeout = vim.o.timeoutlen,
      -- clear line after escaping if there is only whitespace
      clear_empty_lines = true,
    },
  },

  --
  -- [[[ Treesitter ]]]
  --
  -- Highlight, edit and navigate code
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "nix",

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
        "templ",
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

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          include_surrounding_whitespace = true,
          keymaps = {
            ["am"] = { query = "@function.outer", desc = "method" },
            ["im"] = { query = "@function.inner", desc = "method" },
            ["aM"] = { query = "@function.outer", desc = "method" },
            ["iM"] = { query = "@function.inner", desc = "method" },
            ["ac"] = { query = "@call.outer", desc = "function call" },
            ["ic"] = { query = "@call.inner", desc = "function call" },
            ["aC"] = { query = "@call.outer", desc = "function call" },
            ["iC"] = { query = "@call.inner", desc = "function call" },
            ["aa"] = { query = "@parameter.outer", desc = "parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "parameter" },
            ["aA"] = { query = "@parameter.outer", desc = "parameter" },
            ["iA"] = { query = "@parameter.inner", desc = "parameter" },
          },
        },

        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "method start" },
            ["]c"] = { query = "@call.outer", desc = "function call start" },
            ["]a"] = { query = "@parameter.outer", desc = "parameter start" },
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "method end" },
            ["]C"] = { query = "@call.outer", desc = "function call end" },
            ["]A"] = { query = "@parameter.outer", desc = "parameter end" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "method start" },
            ["[c"] = { query = "@call.outer", desc = "function call start" },
            ["[a"] = { query = "@parameter.outer", desc = "parameter start" },
          },
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "method end" },
            ["[C"] = { query = "@call.outer", desc = "function call end" },
            ["[A"] = { query = "@parameter.outer", desc = "parameter end" },
          },
        },
      },

      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Automatically set syntax for certain filetypes
      vim.cmd("autocmd BufRead,BufEnter *.astro set filetype=astro")
      vim.cmd("autocmd BufRead,BufEnter *.templ set filetype=templ")
    end,
  },

  --
  -- [[[ Completion ]]]
  --
  -- LSP
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Auto install & manage LSP servers
      { 'mason-org/mason.nvim', config = true },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local telescope = require('telescope.builtin')
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', telescope.lsp_definitions, 'Go to Definition')
          map('gr', telescope.lsp_references, 'Show all References')
          map('go', telescope.lsp_type_definitions, 'Show Type Definitions')
          map('gv', ':vsplit | lua require("telescope.builtin").lsp_definitions()<CR>', 'Go to Declaration in new vsplit')
          map('gi', telescope.lsp_implementations, 'Show all Implementations')

          map('<leader>sd', telescope.lsp_document_symbols, 'Document Symbols')
          map('<leader>sw', telescope.lsp_dynamic_workspace_symbols, 'Workspace Symbols')

          map('gK', function() vim.lsp.buf.hover { border = 'rounded' } end, 'Hover')
          map('gD', vim.lsp.buf.declaration, 'Go to Declaration')
          map('<C-b>', function() vim.lsp.buf.signature_help { border = 'rounded' } end, 'Show signature help', 'i')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Show Code Actions')

          map('[d', vim.diagnostic.goto_prev, 'Prev Diagnostic')
          map(']d', vim.diagnostic.goto_next, 'Next Diagnostic')
          map('<leader>cd', vim.diagnostic.setloclist, 'Show Diagnostic List')

          map('<leader>ll', function() vim.lsp.buf.format { async = true } end, 'Format')
          map('<leader>lr', ':LspRestart<CR>', 'Restart')
          map('<leader>li', ':LspInfo<CR>', 'Show Info')

          -- Vim diagnostics config
          vim.diagnostic.config {
            virtual_text = { source = 'always' },
            float = { border = 'rounded' }
          }

          -- The following two autocommands are used to highlight references of
          -- the word under your cursor when your cursor rests there for a
          -- little while.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Enable the following language servers
      -- cmd (table): Override the default command used to start the server
      -- filetypes (table): Override the default list of associated filetypes for the server
      -- capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      -- settings (table): Override the default settings passed when initializing the server.
      local servers = {
        emmet_ls = {
          filetypes = {
            "html",
            "php",
            "vue",
            "typescriptreact",
            "javascriptreact",
            "css",
            "sass",
            "scss",
            "less",
          },
        },
        eslint = {},
        intelephense = {},
        html = {},
        cssls = {},
        -- ts_ls = {
        --   filetypes = {
        --     "javascript",
        --     "typescript",
        --     "typescriptreact",
        --     "javascriptreact",
        --     "vue",
        --   },
        -- },
        vue_ls = {
          on_init = function(client)
            client.handlers['tsserver/request'] = function(_, result, context)
              local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
              if #clients == 0 then
                vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.', vim.log.levels
                  .ERROR)
                return
              end
              local ts_client = clients[1]

              local param = unpack(result)
              local id, command, payload = unpack(param)
              ts_client:exec_cmd({
                title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                command = 'typescript.tsserverRequest',
                arguments = {
                  command,
                  payload,
                },
              }, { bufnr = context.bufnr }, function(_, r)
                local response_data = { { id, r.body } }
                ---@diagnostic disable-next-line: param-type-mismatch
                client:notify('tsserver/response', response_data)
              end)
            end
          end,
        },
        vtsls = {
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = '@vue/typescript-plugin',
                    location = vim.fn.stdpath('data')
                        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                    languages = { 'vue' },
                    configNamespace = 'typescript',
                  },
                },
              },
            },
          },
          filetypes = {
            "typescript",
            "javascript",
            "typescriptreact",
            "javascriptreact",
            "vue",
          },
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { "cn\\(([^)]*)\\)",  "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                  { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                },
              },
            },
          },
        },
        graphql = {},
        prismals = {},
        svelte = {},
        astro = {},

        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields`
              -- warnings diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },

        gopls = {},
        templ = {},
      }

      -- Define non-LSP tools to install
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
      })

      -- Install the above servers and tools with Mason
      require('mason').setup()
      require('mason-lspconfig').setup()
      require('mason-tool-installer').setup({
        ensure_installed = ensure_installed
      })
      for server_name, server in pairs(servers) do
        vim.lsp.config(server_name, server)
        vim.lsp.enable(server_name)
      end

      -- Add keybinding for Mason
      vim.keymap.set('n', '<leader>lm', ":Mason<CR>", { desc = "Mason" })
    end,
  },

  -- Completion Window
  {
    "saghen/blink.cmp",
    -- lazy loading handled internally
    lazy = false,
    -- optional: provides snippets for the snippet source
    dependencies = "rafamadriz/friendly-snippets",
    -- use a release tag to download pre-built binaries
    version = '1.*',

    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'enter',
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      },
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
        kind_icons = {
          Text = '[TXT]',
          Method = '[MTH]',
          Function = '[FUN]',
          Constructor = '[CON]',

          Field = '[FLD]',
          Variable = '[VAR]',
          Property = '[PRP]',

          Class = '[CLS]',
          Interface = '[INT]',
          Struct = '[STR]',
          Module = '[MOD]',

          Unit = '[UNI]',
          Value = '[VAL]',
          Enum = '[ENU]',
          EnumMember = '[ENM]',

          Keyword = '[KEY]',
          Constant = '[CST]',

          Snippet = '[SNP]',
          Color = '[CLR]',
          File = '[FIL]',
          Reference = '[REF]',
          Folder = '[DIR]',
          Event = '[EVT]',
          Operator = '[OPR]',
          TypeParameter = '[TYP]',
        },
      },
      completion = {
        list = {
          selection = {
            -- When `true`, inserts the completion item automatically when selecting it
            -- You may want to bind a key to the `cancel` command (default <C-e>) when using this option,
            -- which will both undo the selection and hide the completion menu
            auto_insert = true,
            -- auto_insert = function(ctx) return vim.bo.filetype ~= 'markdown' end
          },
        },
        documentation = {
          -- Controls whether the documentation window will automatically show when selecting a completion item
          auto_show = true,
          -- Delay before showing the documentation window
          auto_show_delay_ms = 100,
          window = { border = 'rounded' }
        },
        menu = {
          draw = {
            -- Components to render, grouped by column
            columns = { { 'label', gap = 1 }, { 'kind_icon' } },
          }
        },
      },
      signature = {
        enabled = true,
        window = { border = 'rounded' }
      },
      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },

  -- AI autocomplete
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    opts = {
      keymaps = {
        accept_suggestion = "<C-l>",
      },
    },
  },

  --
  -- [[[ Integrations ]]]
  --
  -- tmux integration
  {
    "aserowy/tmux.nvim",
    event = "VeryLazy",
    opts = {
      copy_sync = {
        -- enables copy sync and overwrites all register actions to
        -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
        enable = false,

        -- TMUX >= 3.2: yanks (and deletes) will get redirected to system
        -- clipboard by tmux
        redirect_to_clipboard = false,

        -- offset controls where register sync starts
        -- e.g. offset 2 lets registers 0 and 1 untouched
        register_offset = 0,

        -- sync clipboard overwrites vim.g.clipboard to handle * and +
        -- registers. If you sync your system clipboard without tmux, disable
        -- this option!
        sync_clipboard = true,

        -- syncs deletes with tmux clipboard as well, it is adviced to
        -- do so. Nvim does not allow syncing registers 0 and 1 without
        -- overwriting the unnamed register. Thus, ddp would not be possible.
        sync_deletes = true,
      },

      navigation = {
        -- cycles to opposite pane while navigating into the border
        cycle_navigation = true,

        -- enables default keybindings (C-hjkl) for normal mode
        enable_default_keybindings = true,

        -- prevents unzoom tmux when navigating beyond vim border
        persist_zoom = false,
      },

      resize = {
        -- enables default keybindings (A-hjkl) for normal mode
        enable_default_keybindings = true,

        -- sets resize steps for x axis
        resize_step_x = 5,

        -- sets resize steps for y axis
        resize_step_y = 5,
      }
    },
  },
})

-- Define keymap for lazy.nvim
vim.keymap.set("n", "<leader>la", ":Lazy<CR>", { noremap = true, silent = true, desc = "Lazy" })

-- Launch opencode inside nvim
local function open_or_create_opencode_buffer()
  local buffer_name = "opencode"
  local found_bufnr = nil

  -- Iterate through all existing buffers and find the opencode buffer
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if string.find(vim.api.nvim_buf_get_name(bufnr), buffer_name, 1, true) then
      found_bufnr = bufnr
      break
    end
  end

  if found_bufnr then
    -- Iterate through all tabpages and their windows to find where the buffer is
    local found_winid = -1
    local found_tabid = -1
    for _, tabid in ipairs(vim.api.nvim_list_tabpages()) do
      for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabid)) do
        if vim.api.nvim_win_get_buf(winid) == found_bufnr then
          found_winid = winid
          found_tabid = tabid
          break
        end
      end
      if found_winid ~= -1 then
        break -- Found the tab, exit outer loop
      end
    end

    -- Show buffer if it's already open
    if found_winid ~= -1 then
      vim.api.nvim_set_current_tabpage(found_tabid)
      vim.api.nvim_set_current_win(found_winid)
      return
    end

    -- Else open opencode buffer in a vertical split
    vim.cmd("vsplit")
    vim.api.nvim_set_current_buf(found_bufnr)
    return
  end

  -- Opencode buffer doesn't exist, create a new one
  vim.cmd("vsplit")
  vim.cmd("terminal opencode")
  vim.api.nvim_buf_set_name(0, buffer_name) -- 0 refers to the current buffer
end
vim.keymap.set("n", "<leader>oc", open_or_create_opencode_buffer, { desc = "Launch opencode" })
