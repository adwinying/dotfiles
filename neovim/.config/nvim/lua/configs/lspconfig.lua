local present, lspconfig = pcall(require, "lspconfig")

if not present then return end

-- LSP global config
vim.diagnostic.config({
  float = {
    source = 'always',
  },
})

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
  "sumneko_lua",
  "gopls",
  "prismals",
  "svelte",
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>',                                opts)
  buf_set_keymap('n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>',                                 opts)
  buf_set_keymap('n', 'gK',         '<cmd>lua vim.lsp.buf.hover()<CR>',                                      opts)
  buf_set_keymap('n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>',                             opts)
  buf_set_keymap('n', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>',                             opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',                       opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',                    opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', 'gy',         '<cmd>lua vim.lsp.buf.type_definition()<CR>',                            opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',                                     opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',                                opts)
  buf_set_keymap('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>',                                 opts)
  buf_set_keymap('n', '<leader>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',               opts)
  buf_set_keymap('n', '[d',         '<cmd>lua vim.diagnostic.goto_prev()<CR>',                           opts)
  buf_set_keymap('n', ']d',         '<cmd>lua vim.diagnostic.goto_next()<CR>',                           opts)
  buf_set_keymap('n', '<leader>cd', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',                         opts)
  buf_set_keymap('n', '<leader>ll', '<cmd>lua vim.lsp.buf.formatting()<CR>',                                 opts)
  -- eslint autofix linting
  buf_set_keymap('n', '<leader>lk', '<cmd>EslintFixAll<CR>', opts)
  -- restart lsp
  buf_set_keymap('n', '<leader>lr', '<cmd>LspRestart<CR>', opts)
  -- restart eslint lsp
  buf_set_keymap('n', '<leader>ler', '<cmd>LspRestart eslint<CR>', opts)
end

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
      "css",
      "vue",
      "php",
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
