local present1, lsp = pcall(require, "lsp-zero")

if not present1 then return end

local lspconfig = require("configs.lspconfig")
local cmpconfig = require("configs.cmp")

-- load lsp-zero recommended preset
lsp.preset("recommended")

-- override lsp-zero presets
lsp.set_preferences({
  set_lsp_keymaps = false,
  sign_icons = lspconfig.diagnostic_icons,
})

-- configure lsp keybindings
lsp.on_attach(function (client, bufnr)
  lspconfig.keybindings(client, bufnr)
end)

-- install lsp servers
lsp.ensure_installed(lspconfig.servers)

-- load custom LSP configs
for server_name, custom_config in pairs(lspconfig.custom_configs) do
  lsp.configure(server_name, custom_config)
end

-- cmp custom config
lsp.setup_nvim_cmp({
  formatting = cmpconfig.formatting,

  mapping = lsp.defaults.cmp_mappings(cmpconfig.custom_keybindings),
})

lsp.setup()
