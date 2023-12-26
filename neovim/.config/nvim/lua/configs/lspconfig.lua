local diagnostic_icons = {
  error = "E",
  warn = "W",
  hint = "H",
  info = "I"
}

-- LSP servers to install
local servers = {
  "volar",
  "emmet_ls",
  "eslint",
  "intelephense",
  "html",
  "cssls",
  "tsserver",
  "tailwindcss",
  "graphql",
  "lua_ls",
  "prismals",
  "svelte",
  "astro",
}

-- LSP custom configs (optional)
local custom_configs = {
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
    }
  },

  phpactor = {
    init_options = {
      ["language_server_phpstan.enabled"] = true,
      ["language_server_psalm.enabled"] = false,
    }
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

  volar = {
    filetypes = {
      "typescript",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "vue",
      "json"
    }
  }
}

-- LSP keybindings
-- See `:help vim.lsp.*` for documentation on any of the below functions
local keybindings = function (_, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gv', ':vsplit | lua vim.lsp.buf.definition()<CR>', bufopts)
  vim.keymap.set('n', 'gK', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<C-m>', vim.lsp.buf.signature_help, bufopts)

  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)

  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)

  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '<leader>cd', vim.diagnostic.setloclist, bufopts)

  vim.keymap.set('n', '<leader>ll', function() vim.lsp.buf.format { async = true } end, bufopts)
  -- eslint autofix linting
  vim.keymap.set('n', '<leader>lk', '<cmd>EslintFixAll<CR>', bufopts)
  -- restart lsp
  vim.keymap.set('n', '<leader>lr', '<cmd>LspRestart<CR>', bufopts)
  vim.keymap.set('n', '<leader>li', '<cmd>LspInfo<CR>', bufopts)
end

return {
  servers = servers,
  diagnostic_icons = diagnostic_icons,
  custom_configs = custom_configs,
  keybindings = keybindings,
}
