return {
  -- LSP
  {
    'VonHeikemen/lsp-zero.nvim',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    },

    config = function()
      local lsp = require("lsp-zero")
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
      lsp.on_attach(function(client, bufnr)
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
        mapping = cmpconfig.custom_keybindings,
        sources = cmpconfig.sources,
      })

      lsp.setup()

      -- show diagnostics
      vim.diagnostic.config({
        virtual_text = true,
      })

      -- add mason keybinding
      vim.keymap.set('n', '<leader>lm', "<CMD>Mason<CR>", { desc = "Mason" })
    end,
  },
}
