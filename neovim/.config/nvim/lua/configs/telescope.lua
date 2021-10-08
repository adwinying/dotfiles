local present, telescope = pcall(require, "telescope")

if not present then return end

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
