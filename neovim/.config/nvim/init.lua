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

-- key mapper helper
local function mapKey(mode, l, r, desc)
  vim.keymap.set(mode, l, r, { noremap = true, silent = true, desc = desc })
end

--
-- [[ Plugins ]]
--
do
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ""
      local stdout = result.stdout or ""
      local output = stderr ~= "" and stderr or stdout
      if output == "" then output = "No output from build command." end
      vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- This autocommand runs after a plugin is installed or updated and
  --  runs the appropriate build command for that plugin if necessary.
  --
  -- See `:help vim.pack-events`
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= "install" and kind ~= "update" then return end

      if name == "telescope-fzf-native.nvim" and vim.fn.executable "make" == 1 then
        run_build(name, { "make" }, ev.data.path)
        return
      end

      if name == "LuaSnip" then
        if vim.fn.has "win32" ~= 1 and vim.fn.executable "make" == 1 then
          run_build(name, { "make", "install_jsregexp" }, ev.data.path)
        end
        return
      end

      if name == "nvim-treesitter" then
        if not ev.data.active then vim.cmd.packadd "nvim-treesitter" end
        vim.cmd "TSUpdate"
        return
      end
    end,
  })

  mapKey("n", "<leader>ps", ":checkhealth vim.pack<CR>", "Plugin Status")
  mapKey("n", "<leader>pu", ":lua vim.pack.update()<CR>PackerUpdate", "Update Plugins")
end


-- Because most plugins are hosted on GitHub, you can use the helper
-- function to have less repetition in the following sections.
-- @param repo string
-- @return string
local function gh(repo) return "https://github.com/" .. repo end

--
-- [[ UI ]]
--
do
  -- Color scheme
  do
    vim.pack.add { gh "arcticicestudio/nord-vim" }

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
  end

  -- Preview hexcode colors
  do
    vim.pack.add { gh "NvChad/nvim-colorizer.lua" }

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
  end

  -- Status bar
  do
    vim.pack.add { gh "nvim-lualine/lualine.nvim" }

    require("lualine").setup({
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
    })
  end

  -- File explorer
  do
    vim.pack.add { gh "stevearc/oil.nvim" }
    require("oil").setup({
      keymaps = {
        ["`"] = false,
        ["~"] = false,
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
    })

    mapKey("n", "<leader>j", ":vsplit<CR>:e %:p:h<CR>", "Explore current dir")
  end

  -- "Smooth" scrolling
  do
    vim.pack.add { gh "terryma/vim-smooth-scroll" }
    mapKey("n", "<C-U>", ":call smooth_scroll#up(&scroll, 0, 4)<CR>")
    mapKey("n", "<C-D>", ":call smooth_scroll#down(&scroll, 0, 4)<CR>")
    mapKey("n", "<C-B>", ":call smooth_scroll#up(&scroll*2, 0, 4)<CR>")
    mapKey("n", "<C-F>", ":call smooth_scroll#down(&scroll*2, 0, 4)<CR>")
  end

  -- Keybinding hints
  do
    vim.pack.add { gh "folke/which-key.nvim" }
    require("which-key").setup({
      icons = {
        mappings = false,
      },
    })
  end

  -- Git signs
  do
    vim.pack.add {
      gh "nvim-lua/plenary.nvim",
      gh "lewis6991/gitsigns.nvim",
    }
    require("gitsigns").setup({
      signs        = {
        add          = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change       = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        delete       = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        topdelete    = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
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
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
        map("v", "<leader>hs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end, "Stage Hunk")
        map("v", "<leader>hr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", function() gs.blame_line { full = true } end, "Blame Line")
        map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle Blame")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff This ~")
        map("n", "<leader>td", gs.toggle_deleted, "Toggle Deleted")

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
      end,

      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      preview_config = {
        border = "rounded",
      },
    })
  end

  -- Telescope
  do
    local plugins = {
      gh "nvim-lua/plenary.nvim",
      gh "nvim-telescope/telescope.nvim",
      gh "nvim-telescope/telescope-media-files.nvim",
      gh "nvim-telescope/telescope-fzf-native.nvim",
    }
    if vim.fn.executable "make" == 1 then
      table.insert(plugins, gh "nvim-telescope/telescope-fzf-native.nvim")
    end
    vim.pack.add(plugins)

    require("telescope").setup({
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
    })

    -- Load fzf extension
    pcall(require("telescope").load_extension, "fzf")

    -- Load media_files extension if ueberzug exists
    if vim.fn.executable "ueberzug" == 1 then
      pcall(require("telescope").load_extension, "media_files")
    end

    mapKey("n", "<leader>ff",  "<CMD>Telescope find_files <CR>",             "Find Files")
    mapKey("n", "<leader>fa",  "<CMD>Telescope find_files hidden=true <CR>", "Find Files (+ hidden)")
    mapKey("n", "<leader>fb",  "<CMD>Telescope buffers <CR>",                "Find Buffers")
    mapKey("n", "<leader>fh",  "<CMD>Telescope help_tags <CR>",              "Find Help Tags")
    mapKey("n", "<leader>fw",  "<CMD>Telescope live_grep <CR>",              "Grep")
    mapKey("n", "<leader>fz",  "<CMD>Telescope grep_string <CR>",            "Word")
    mapKey("n", "<leader>fgc", "<CMD>Telescope git_bcommits <CR>",           "Find Git Commits")
    mapKey("n", "<leader>fgs", "<CMD>Telescope git_status <CR>",             "Find Git Status")
    mapKey("n", "<leader>f:",  "<CMD>Telescope command_history <CR>",        "Find Command History")
    mapKey("n", "<leader>fc",  "<CMD>Telescope commands <CR>",               "Find Commands")
    mapKey("n", "<leader>fm",  "<CMD>Telescope media_files <CR>",            "Find Media Files")
    mapKey("n", "<leader>fr",  "<CMD>Telescope resume <CR>",                 "Resume")
  end

  -- Project-wide grep
  do
    vim.pack.add {
      gh "nvim-lua/plenary.nvim",
      gh "windwp/nvim-spectre",
    }
    require("spectre").setup({
      replace_engine = { sed = { cmd = "sed" } }
    })
    mapKey("n", "<leader>fs", function() require("spectre").open() end, "Replace in files (Spectre)")
  end
end

--
-- [[[ Editor ]]]
--
do
  -- Advanced substitution
  do
    vim.pack.add { gh "tpope/vim-abolish" }
  end

  -- Comments
  do
    vim.pack.add {
      gh "JoosepAlviste/nvim-ts-context-commentstring",
      gh "nvim-mini/mini.comment",
    }

    require("ts_context_commentstring").setup({
      enable_autocmd = false,
    })

    require("mini.comment").setup({
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring").calculate_commentstring()
              or vim.bo.commentstring
        end,
      },
    })
  end

  -- Surround motions
  do
    vim.pack.add { gh "nvim-mini/mini.surround" }

    require("mini.surround").setup({
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",

        -- Add this only if you don"t want to use extended mappings
        suffix_last = "",
        suffix_next = "",
      },
      search_method = "cover_or_next",
    })

    vim.keymap.set("n", "yss", "ys_", { remap = true })
  end

  -- Align blocks of text
  do
    vim.pack.add { gh "nvim-mini/mini.align" }
    require("mini.align").setup()
  end

  -- Auto insert matching brackets
  do
    vim.pack.add { gh "nvim-mini/mini.pairs" }
    require("mini.pairs").setup()
  end

  -- Split/combine multi params on a single line
  do
    vim.pack.add { gh "nvim-mini/mini.splitjoin" }

    local msj = require("mini.splitjoin")
    local gen_hook = msj.gen_hook
    local curly = { brackets = { "%b{}" } }

    local add_trailing_separator = gen_hook.add_trailing_separator()
    local del_trailing_separator = gen_hook.del_trailing_separator()
    local pad_curlys = gen_hook.pad_brackets(curly)

    local config = {
      split =  { hooks_post = { add_trailing_separator } },
      join = { hooks_post = { del_trailing_separator, pad_curlys } }
    }

    msj.setup(config)
  end

  -- Better escape
  do
    vim.pack.add { gh "max397574/better-escape.nvim" }

    local escape_and_clear = function ()
      vim.api.nvim_input("<Esc>")
      local current_line = vim.api.nvim_get_current_line()
      if current_line:match("^%s+.$") then
        vim.schedule(function() vim.api.nvim_set_current_line("") end)
      end
    end

    require("better_escape").setup({
      default_mappings = true,
      -- a table with mappings to use
      mappings = {
        -- i for insert
        i = {
          j = {
            -- These can all also be functions
            k = escape_and_clear,
            j = escape_and_clear,
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
            k = escape_and_clear,
          },
        },
        s = {
          j = {
            k = escape_and_clear,
          },
        },
      },
      -- the time in which the keys must be hit in ms
      timeout = vim.o.timeoutlen,
    })
  end
end

--
-- [[[ Treesitter ]]]
--
do
  vim.pack.add {
    { src = gh "nvim-treesitter/nvim-treesitter", version = "main" },
    gh "nvim-treesitter/nvim-treesitter-textobjects",
  }

  -- Ensure the following parsers are installed
  require("nvim-treesitter").install({
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
  })

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Check if treesitter indentation is available for this language, and if
    -- so enable it in case there is no indent query, the indentexpr will
    -- fallback to the vim"s built in one
    local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

    -- Enable treesitter based indentation
    if has_indent_query then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end

  local available_parsers = require("nvim-treesitter").get_available()
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require("nvim-treesitter").get_installed("parsers")

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- If a parser is available in `nvim-treesitter`, auto-install it and
        -- enable it after the installation is done
        require("nvim-treesitter").install(language):await(
          function() treesitter_try_attach(buf, language) end
        )
      else
        -- Try to enable treesitter features in case the parser exists but is
        -- not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })

  require("nvim-treesitter-textobjects").setup({
    textobjects = {
      select = {
        lookahead = true,
        include_surrounding_whitespace = true,
      },
      move = {
        set_jumps = true,
      },
    },
  })

  -- Keymaps
  mapKey({ "x", "o" }, "am", function() require "nvim-treesitter-textobjects.select".select_textobject("@function.outer",  "textobjects") end, "Method")
  mapKey({ "x", "o" }, "im", function() require "nvim-treesitter-textobjects.select".select_textobject("@function.inner",  "textobjects") end, "Method")
  mapKey({ "x", "o" }, "ac", function() require "nvim-treesitter-textobjects.select".select_textobject("@class.outer",     "textobjects") end, "Class")
  mapKey({ "x", "o" }, "ic", function() require "nvim-treesitter-textobjects.select".select_textobject("@class.inner",     "textobjects") end, "Class")
  mapKey({ "x", "o" }, "aa", function() require "nvim-treesitter-textobjects.select".select_textobject("@parameter.outer", "textobjects") end, "Parameter")
  mapKey({ "x", "o" }, "ia", function() require "nvim-treesitter-textobjects.select".select_textobject("@parameter.inner", "textobjects") end, "Parameter")

  mapKey({ "n", "x", "o" }, "]m", function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer",  "textobjects") end, "Next Method Start")
  mapKey({ "n", "x", "o" }, "]c", function() require("nvim-treesitter-textobjects.move").goto_next_start("@call.outer",      "textobjects") end, "Next Function Call Start")
  mapKey({ "n", "x", "o" }, "]a", function() require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.outer", "textobjects") end, "Next Parameter Start")
  mapKey({ "n", "x", "o" }, "]M", function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer",    "textobjects") end, "Next Method End")
  mapKey({ "n", "x", "o" }, "]C", function() require("nvim-treesitter-textobjects.move").goto_next_end("@call.outer",        "textobjects") end, "Next Function Call End")
  mapKey({ "n", "x", "o" }, "]A", function() require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.outer",   "textobjects") end, "Next Parameter End")

  mapKey({ "n", "x", "o" }, "[m", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer",  "textobjects") end, "Previous Method Start")
  mapKey({ "n", "x", "o" }, "[c", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@call.outer",      "textobjects") end, "Previous Function Call Start")
  mapKey({ "n", "x", "o" }, "[a", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.outer", "textobjects") end, "Previous Parameter Start")
  mapKey({ "n", "x", "o" }, "[M", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer",    "textobjects") end, "Previous Method End")
  mapKey({ "n", "x", "o" }, "[C", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@call.outer",        "textobjects") end, "Previous Function Call End")
  mapKey({ "n", "x", "o" }, "[A", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.outer",   "textobjects") end, "Previous Parameter End")

  -- Automatically set syntax for certain filetypes
  vim.cmd("autocmd BufRead,BufEnter *.astro set filetype=astro")
  vim.cmd("autocmd BufRead,BufEnter *.templ set filetype=templ")
end

--
-- [[[ Completion ]]]
--
do
  -- LSP
  do
    vim.pack.add {
      gh "mason-org/mason.nvim", -- Auto install & manage LSP servers
      gh "mason-org/mason-lspconfig.nvim",
      gh "WhoIsSethDaniel/mason-tool-installer.nvim",
      gh "neovim/nvim-lspconfig",
    }

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local telescope = require("telescope.builtin")
        local map = function(keys, func, desc, mode)
          vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", telescope.lsp_definitions, "Go to Definition")
        map("gr", telescope.lsp_references, "Show all References")
        map("go", telescope.lsp_type_definitions, "Show Type Definitions")
        map("gv", ":vsplit | lua require('telescope.builtin').lsp_definitions()<CR>", "Go to Declaration in new vsplit")
        map("gi", telescope.lsp_implementations, "Show all Implementations")

        map("<leader>sd", telescope.lsp_document_symbols, "Document Symbols")
        map("<leader>sw", telescope.lsp_dynamic_workspace_symbols, "Workspace Symbols")

        map("gK", function() vim.lsp.buf.hover { border = "rounded" } end, "Hover")
        map("gD", vim.lsp.buf.declaration, "Go to Declaration")
        map("<C-b>", function() vim.lsp.buf.signature_help { border = "rounded" } end, "Show signature help", "i")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Show Code Actions")

        map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev Diagnostic")
        map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next Diagnostic")
        map("<leader>cd", vim.diagnostic.setloclist, "Show Diagnostic List")

        map("<leader>ll", function() vim.lsp.buf.format { async = true } end, "Format")
        map("<leader>lr", ":lsp restart<CR>", "Restart")
        map("<leader>li", ":checkhealth vim.lsp<CR>", "Show Info")

        -- Vim diagnostics config
        vim.diagnostic.config {
          virtual_text = { source = true },
          float = { border = "rounded" },
          jump = {
            on_jump = function(diagnostic)
              if diagnostic then
                vim.diagnostic.open_float { focusable = false }
              end
            end,
          },
        }

        -- The following two autocommands are used to highlight references of
        -- the word under your cursor when your cursor rests there for a
        -- little while.
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
            end,
          })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "[T]oggle Inlay [H]ints")
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
      vue_ls = {
        on_init = function(client)
          client.handlers["tsserver/request"] = function(_, result, context)
            local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
            if #clients == 0 then
              vim.notify("Could not find `vtsls` lsp client, `vue_ls` would not work without it.", vim.log.levels
                .ERROR)
              return
            end
            local ts_client = clients[1]

            local param = unpack(result)
            local id, command, payload = unpack(param)
            ts_client:exec_cmd({
              title = "vue_request_forward", -- You can give title anything as it"s used to represent a command in the UI, `:h Client:exec_cmd`
              command = "typescript.tsserverRequest",
              arguments = {
                command,
                payload,
              },
            }, { bufnr = context.bufnr }, function(_, r)
              local response_data = { { id, r.body } }
              ---@diagnostic disable-next-line: param-type-mismatch
              client:notify("tsserver/response", response_data)
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
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath("data")
                      .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
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
              callSnippet = "Replace",
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        },
      },

      jdtls = {
        cmd = {
          "jdtls",
          "-configuration",
          vim.fn.expand"$HOME/.cache/jdtls/config",
          "-data",
          vim.fn.expand"$HOME/.cache/jdtls/workspace",
          ("--jvm-arg=-javaagent:%s"):format(vim.fn.expand"$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar"),
        },
      },

      gopls = {},
      templ = {},
    }

    -- Define non-LSP tools to install
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua",
    })

    -- Install the above servers and tools with Mason
    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-tool-installer").setup({
      ensure_installed = ensure_installed
    })
    for server_name, server in pairs(servers) do
      vim.lsp.config(server_name, server)
      vim.lsp.enable(server_name)
    end

    -- Add keybinding for Mason
    vim.keymap.set("n", "<leader>lm", ":Mason<CR>", { desc = "Mason" })
  end

  -- Linting
  do
    vim.pack.add {
      -- Auto install & manage LSP servers
      gh "mason-org/mason.nvim",
      gh "rshkarin/mason-nvim-lint",
      gh "mfussenegger/nvim-lint",
    }

    local lint = require("lint")
    lint.linters_by_ft = {
      -- markdown = { "markdownlint" },
      -- php = { "phpstan" },
    }

    -- Create autocommand which carries out the actual linting
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Only run the linter in buffers that you can modify in order to
        -- avoid superfluous noise, notably within the handy LSP pop-ups that
        -- describe the hovered symbol using Markdown.
        if vim.bo.modifiable then
          lint.try_lint()
        end
      end,
    })
  end

  -- Completion Window
  do
    vim.pack.add {
      -- provides snippets for the snippet source
      gh "rafamadriz/friendly-snippets",
      -- use a release tag to download pre-built binaries
      { src = gh "saghen/blink.cmp", version = vim.version.range "1.*" },
    }

    require("blink.cmp").setup({
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
    })
  end

  -- AI autocomplete
  do
    vim.pack.add { gh "supermaven-inc/supermaven-nvim" }
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<C-l>",
      },
    })
  end
end

--
-- [[[ Integrations ]]]
--
do
  -- tmux integration
  do
    vim.pack.add { gh "aserowy/tmux.nvim" }

    require("tmux").setup({
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
    })
  end

  -- Launch opencode inside nvim
  do
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
  end
end
