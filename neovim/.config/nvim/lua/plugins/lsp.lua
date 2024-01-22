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
      { 'jay-babu/mason-null-ls.nvim' },
      { 'nvimtools/none-ls.nvim' },

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

      -- disable tsserver when volar is active
      local lsp_conficts, _ = pcall(
        vim.api.nvim_get_autocmds,
        { group = "LspAttach_conflicts" }
      )
      if not lsp_conficts then
        vim.api.nvim_create_augroup("LspAttach_conflicts", {})
      end
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_conflicts",
        desc = "prevent tsserver and volar competing",
        callback = function(args)
          if not (args.data and args.data.client_id) then return end

          local active_clients = vim.lsp.get_active_clients()
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          -- prevent tsserver and volar competing
          if client.name == "volar" then
            for _, client_ in pairs(active_clients) do
              -- stop tsserver if volar is already active
              if client_.name == "tsserver" then client_.stop() end
            end
          elseif client.name == "tsserver" then
            for _, client_ in pairs(active_clients) do
              -- prevent tsserver from starting if volar is already active
              if client_.name == "volar" then client.stop() end
            end
          end
        end,
      })

      -- null-ls
      local null_ls = require('null-ls')
      local mason_null_ls = require('mason-null-ls')

      null_ls.setup()
      mason_null_ls.setup({
        ensure_installed = {
          'eslint_d',
        },

        on_attach = function(client, bufnr)
          lsp.build_options('null-ls', {}).on_attach(client, bufnr)
        end,

        handlers = {},
      })
    end,
  },
}
