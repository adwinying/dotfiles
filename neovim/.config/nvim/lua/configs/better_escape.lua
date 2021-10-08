local present, better_escape = pcall(require, "better_escape")

if not present then return end

better_escape.setup {
  -- a table with mappings to use
  mappings = { "jk" },
  -- the time in which the keys must be hit in ms
  timeout = vim.o.timeoutlen,
  -- clear line after escaping if there is only whitespace
  clear_empty_lines = true,
  -- keys used for escaping, if it is a function will use the result everytime
  -- example
  -- keys = function()
  --   return vim.fn.col '.' - 2 >= 1 and '<esc>l' or '<esc>'
  -- end,
  keys = "<Esc>",
}
