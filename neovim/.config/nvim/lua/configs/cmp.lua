local present, cmp = pcall(require, "cmp")

if not present then return end

local custom_keybindings = {
  ['<CR>'] = cmp.mapping.confirm({select = false}),
  ['<C-e>'] = cmp.mapping.close(),

  ["<C-p>"] = cmp.mapping.select_prev_item(),
  ["<C-n>"] = cmp.mapping.select_next_item(),

  ["<C-u>"] = cmp.mapping.scroll_docs(-5),
  ["<C-d>"] = cmp.mapping.scroll_docs(5),

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

  ["<Tab>"] = nil,
  ["<S-Tab>"] = nil,
}

local formatting = {
  format = function(entry, vim_item)
    vim_item.menu = ({
      path                    = "[PTH]",
      nvim_lsp                = "[LSP]",
      buffer                  = "[BUF]",
      luasnip                 = "[SNP]",
      nvim_lua                = "[LUA]",
      nvim_lsp_signature_help = "[SIG]",
    })[entry.source.name]

    return vim_item
  end,
}

local sources = {
  { name = 'path' },
  { name = 'nvim_lsp', keyword_length = 3 },
  { name = 'buffer', keyword_length = 3 },
  { name = 'luasnip', keyword_length = 2 },
  { name = 'nvim_lua', keyword_length = 3 },
  { name = 'nvim_lsp_signature_help' },
}

return {
  custom_keybindings = custom_keybindings,
  formatting = formatting,
  sources = sources,
}
