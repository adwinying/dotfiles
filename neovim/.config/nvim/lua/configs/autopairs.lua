local present1, autopairs = pcall(require, "nvim-autopairs")
local present2, autopairs_cmp = pcall(require, "nvim-autopairs.completion.cmp")

if not (present1 or present2) then return end

autopairs.setup()
autopairs_cmp.setup {
  --  map <CR> on insert mode
  map_cr = true,
  -- it will auto insert `(` (map_char) after select function or method item
  map_complete = true,
  -- automatically select the first item
  auto_select = true,
  -- use insert confirm behavior instead of replace
  insert = false,
  -- modifies the function or method delimiter by filetypes
  map_char = {
    all = '(',
    tex = '{'
  }
}
