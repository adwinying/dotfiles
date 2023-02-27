return {
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
}
