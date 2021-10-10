local present, cmp = pcall(require, "cmp")

if not present then return end

vim.opt.completeopt = "menuone,noselect"

cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip  = "[SNP]",
        buffer   = "[BUF]",
        nvim_lua = "[LUA]",
        path     = "[PTH]",
      })[entry.source.name]

      return vim_item
    end,
  },

  mapping = {
    ["<C-p>"]     = cmp.mapping.select_prev_item(),
    ["<C-n>"]     = cmp.mapping.select_next_item(),
    ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
    ["<C-d>"]     = cmp.mapping.scroll_docs(4),
    ['<C-e>']     = cmp.mapping.close(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm(),

    ["<C-j>"] = function(fallback)
      if require("luasnip").expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
          "<Plug>luasnip-expand-or-jump",
          true,
          true,
          true
        ), "")
      else
        fallback()
      end
    end,

    ["<C-k>"] = function(fallback)
      if require("luasnip").jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
          "<Plug>luasnip-jump-prev",
          true,
          true,
          true
        ), "")
      else
        fallback()
      end
    end,
  },

  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
  },
}
