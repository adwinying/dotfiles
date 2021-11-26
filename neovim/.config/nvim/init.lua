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

-- init neovim-only configs
require("config")

-- init plugins
require("plugins")
