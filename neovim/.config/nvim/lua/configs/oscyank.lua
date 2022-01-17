-- copy contents of + register to clipboard
vim.cmd([[
  autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
]])
