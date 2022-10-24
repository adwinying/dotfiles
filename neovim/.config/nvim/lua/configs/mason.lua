local present1, mason = pcall(require, "mason")
local present2, mason_lspconfig = pcall(require, "mason-lspconfig")

if not present1 or not present2 then return end

mason.setup()
mason_lspconfig.setup({
  -- Whether servers that are set up (via lspconfig) should be automatically
  -- installed if they're not already installed.
  -- This setting has no relation with the `ensure_installed` setting.
  -- Can either be:
  --   - false: Servers are not automatically installed.
  --   - true: All servers set up via lspconfig are automatically installed.
  --   - { exclude: string[] }: All servers set up via lspconfig, except the
  --     ones provided in the list, are automatically installed.
  automatic_installation = true,
})
