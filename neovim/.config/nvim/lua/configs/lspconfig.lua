local present1, nvim_lsp = pcall(require, "lspconfig")
local present2, lspinstall = pcall(require, "lspinstall")

if not present1 or not present2 then return end

-- servers to manually load
local servers = {
}

-- define custom configs if required
local custom_configs = {
  typescript = function (config)
    config.filetypes = {
      "javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx",
    }

    return config
  end,

  lua = function (config)
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

  volar = function (config)
    -- disable formatting feature
    config.init_options = { documentFormatting = false }

    return config
  end,

  html = function (config)
    -- disable formatting feature
    config.init_options = { documentFormatting = false }

    return config
  end,

  emmet = function (config)
    config.filetypes = {
      "html",
      "css",
      "vue",
      "php",
    }

    return config
  end,

  efm = function (config)
    -- Super hacky workaround to automate installation of eslint_d
    -- by using volar's lspinstall script
    local eslint_d_path = require("lspinstall/util").install_path("volar")
      .. "/node_modules/.bin/eslint_d"

    -- eslint configs ripped off from here
    -- https://github.com/martinsione/dotfiles/blob/master/src/.config/nvim/lua/modules/config/nvim-lspconfig/format.lua
    local eslint = {
      lintCommand = eslint_d_path .. " -f unix --stdin --stdin-filename ${INPUT}",
      lintStdin = true,
      lintIgnoreExitCode = true,
      lintFormats = { "%f:%l:%c: %m" },
      formatCommand = eslint_d_path .. " --fix-to-stdout --stdin --stdin-filename=${INPUT}",
      formatStdin = true,
    }

    config.init_options = {
      documentFormatting = true,
      codeAction = true,
    }

    config.settings = {
      languages = {
        vue             = { eslint },
        javascript      = { eslint },
        javascriptreact = { eslint },
        typescript      = { eslint },
        typescriptreact = { eslint },
      },
    }

    config.filetypes = {
      "vue",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    }

    return config
  end
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
  buf_set_keymap('n', '[d',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',                           opts)
  buf_set_keymap('n', ']d',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',                           opts)
  buf_set_keymap('n', '<leader>cd', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',                         opts)
  buf_set_keymap('n', '<leader>ll', '<cmd>lua vim.lsp.buf.formatting()<CR>',                                 opts)
end

-- make config for a server
local make_config = function (server)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

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

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local setup_servers = function ()
  -- Load custom lspinstall configs
  require("configs.lspinstall")

  -- Init configs for servers installed by lspinstall
  lspinstall.setup()

  -- load servers installed by lspinstall
  for _, server in ipairs(lspinstall.installed_servers()) do
    table.insert(servers, server)
  end

  for _, server in ipairs(servers) do
    nvim_lsp[server].setup(make_config(server))
  end
end

-- Initialize lsp configs
setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function ()
  -- reload installed servers
  setup_servers()
  -- this triggers the FileType autocmd that starts the server
  vim.cmd("bufdo e")
end
