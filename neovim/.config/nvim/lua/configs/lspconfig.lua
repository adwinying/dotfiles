local present, lspconfig = pcall(require, "lspconfig")

if not present then return end

-- LSP global config
vim.diagnostic.config({
  float = {
    -- Show diagnostic source
    source = 'always',
  },
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gK', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '<leader>cd', vim.diagnostic.setloclist, bufopts)
  vim.keymap.set('n', '<leader>ll', function() vim.lsp.buf.format { async = true } end, bufopts)
  -- eslint autofix linting
  vim.keymap.set('n', '<leader>lk', '<cmd>EslintFixAll<CR>', bufopts)
  -- restart lsp
  vim.keymap.set('n', '<leader>lr', '<cmd>LspRestart<CR>', bufopts)
end

-- LSP servers to install
local lsp_servers = {
  "volar",
  "emmet_ls",
  "eslint",
  "intelephense",
  "phpactor",
  "html",
  "cssls",
  "tsserver",
  "tailwindcss",
  "graphql",
  "sumneko_lua",
  "gopls",
  "prismals",
  "svelte",
}

-- define custom configs if required
local custom_configs = {
  sumneko_lua = function (config)
    config.settings = {
      Lua = {
        runtime = {
          -- LuaJIT in the case of Neovim
          version = "LuaJIT",
          path = vim.split(package.path, ';'),
        },

        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim", "hs" },
        },

        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            unpack(vim.api.nvim_get_runtime_file("", true)),
            "/usr/lib/lua",
            "/usr/lib/lua-pam",
            "/usr/share/awesome/lib",
            "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
          },
        },
      },
    }

    return config
  end,

  emmet_ls = function (config)
    config.filetypes = {
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

    return config
  end,

  phpactor = function (config)
    config.init_options = {
        ["language_server_phpstan.enabled"] = true,
        ["language_server_psalm.enabled"] = false,
    }

    return config
  end,
}

-- make config for a server
local make_config = function (server)
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local config = {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,

    flags = { debounce_text_changes = 150 },
  }

  local apply_custom_config = custom_configs[server]

  if apply_custom_config ~= nil then
    config = apply_custom_config(config)
  end

  return config
end

-- Load LSP servers
for _, server_name in ipairs(lsp_servers) do
  local config = make_config(server_name)

  lspconfig[server_name].setup(config)
end
