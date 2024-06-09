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
    config = function ()
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
        map('n', ']h', gs.next_hunk, 'Next Hunk')
        map('n', '[h', gs.prev_hunk, 'Prev Hunk')

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
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
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
    keys = {
      { "<leader>fs", function () require("spectre").open() end, desc = "Replace in files (Spectre)" },
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
        config = function ()
          require('ts_context_commentstring').setup({
            enable_autocmd = false,
          })
        end,
      },
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function ()
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
      mappings = { "jk" },
      -- the time in which the keys must be hit in ms
      timeout = vim.o.timeoutlen,
      -- clear line after escaping if there is only whitespace
      clear_empty_lines = true,
      -- keys used for escaping, if it is a function will use the result everytime
      -- example
      -- keys = function()
      --   return vim.fn.col '.' - 2 >= 1 and '<esc>l' or '<esc>'
      -- end,
      keys = "<Esc>",
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
    config = function (_, opts)
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
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
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

          map('gK', vim.lsp.buf.hover, 'Hover')
          map('gD', vim.lsp.buf.declaration, 'Go to Declaration')
          map('<C-b>', vim.lsp.buf.signature_help, 'Show signature help', 'i')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Show Code Actions')

          map('[d', vim.diagnostic.goto_prev, 'Prev Diagnostic')
          map(']d', vim.diagnostic.goto_next, 'Next Diagnostic')
          map('<leader>cd', vim.diagnostic.setloclist, 'Show Diagnostic List')

          map('<leader>ll', function() vim.lsp.buf.format { async = true } end, 'Format')
          map('<leader>lk', ':EslintFixAll<CR>', 'Fix all ESLint issues')
          map('<leader>lr', ':LspRestart<CR>', 'Restart')
          map('<leader>li', ':LspInfo<CR>', 'Show Info')

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

      -- LSP servers and clients are able to communicate to each other what
      -- features they support. By default, Neovim doesn't support everything
      -- that is in the LSP specification. When you add nvim-cmp, luasnip, etc.
      -- Neovim now has *more* capabilities. So, we create new capabilities
      -- with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      -- cmd (table): Override the default command used to start the server
      -- filetypes (table): Override the default list of associated filetypes for the server
      -- capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      -- settings (table): Override the default settings passed when initializing the server.
      local servers = {
        volar = {},
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
        tsserver = {
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = require('mason-registry')
                  .get_package('vue-language-server'):get_install_path()
                  .. '/node_modules/@vue/language-server'
                  .. '/node_modules/@vue/typescript-plugin',
                languages = {"javascript", "typescript", "vue"},
              },
            },
          },
          filetypes = {
            "javascript",
            "typescript",
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
                  { "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
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
      require('mason-tool-installer').setup({
        ensure_installed = ensure_installed
      })
      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
      vim.keymap.set('n', '<leader>lm', ":Mason<CR>", { desc = "Mason" })
    end,
  },

  -- Completion Window
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {
          history = true,
          delete_check_events = "TextChanged",
        },
        keys = {
          {
            "<tab>",
            function()
              return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
            end,
            expr = true, silent = true, mode = "i",
          },
          { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
          { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        },
      },

      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        completion = { completeopt = 'menu,menuone,noinsert' },

        mapping = cmp.mapping.preset.insert {
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<C-e>'] = cmp.mapping.close(),

          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),

          ["<C-u>"] = cmp.mapping.scroll_docs(-5),
          ["<C-d>"] = cmp.mapping.scroll_docs(5),

          ["<C-j>"] = function(fallback)
            if require("luasnip").expand_or_jumpable() then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                "<Plug>luasnip-expand-or-jump",
                true,
                true,
                true
              ), "")
            else
              fallback()
            end
          end,

          ["<C-k>"] = function(fallback)
            if require("luasnip").jumpable(-1) then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                "<Plug>luasnip-jump-prev",
                true,
                true,
                true
              ), "")
            else
              fallback()
            end
          end,

          ["<Tab>"] = nil,
          ["<S-Tab>"] = nil,
        },

        sources = {
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'luasnip' },
          { name = 'nvim_lsp_signature_help' },
          {
            name = "lazydev",
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
          },
        },

        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              path                    = "[PTH]",
              nvim_lsp                = "[LSP]",
              buffer                  = "[BUF]",
              luasnip                 = "[SNP]",
              nvim_lua                = "[LUA]",
              nvim_lsp_signature_help = "[SIG]",
            })[entry.source.name]

            return vim_item
          end,
        },
      })
    end,
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
