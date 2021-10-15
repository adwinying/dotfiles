--
--  _  _ ___ _____   _____ __  __
-- | \| | __/ _ \ \ / /_ _|  \/  |
-- | .` | _| (_) \ V / | || |\/| |
-- |_|\_|___\___/ \_/ |___|_|  |_|
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
