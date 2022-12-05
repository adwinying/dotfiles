local present, cmp = pcall(require, "cmp")

if not present then return end

local custom_keybindings = {
  ["<C-p>"] = cmp.mapping.select_prev_item(),
  ["<C-n>"] = cmp.mapping.select_next_item(),

  ["<C-d>"] = cmp.mapping.scroll_docs(5),
  ["<C-u>"] = cmp.mapping.scroll_docs(-5),

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
}

local formatting = {
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
}

return {
  custom_keybindings = custom_keybindings,
  formatting = formatting,
}
