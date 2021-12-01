local colors = require "../colors"

-- disable bg color
vim.cmd("highlight Normal guibg=NONE")
vim.cmd("highlight SignColumn guibg=NONE")
vim.cmd("highlight VertSplit guibg=NONE")

-- LSP color highlight
vim.cmd("highlight DiagnosticError guifg=" .. colors.red)
vim.cmd("highlight DiagnosticWarn guifg=" .. colors.yellow)
vim.cmd("highlight DiagnosticInfo guifg=" .. colors.lightblue)
vim.cmd("highlight DiagnosticHint guifg=" .. colors.cyan)
