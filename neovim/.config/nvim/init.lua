--
-- neovim config
--

local fn = vim.fn
local cmd = vim.cmd

-- source basic configs from vim
cmd("source " .. fn.stdpath("config") .. "/basic.vim")

-- define LspInstallAll command
cmd(string.format(
  "command LspInstallAll source %s/lua/scripts/lspinstall.lua",
  fn.stdpath("config")
))

-- init plugins
require("plugins")
