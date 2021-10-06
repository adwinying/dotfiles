--
-- neovim config
--

local fn = vim.fn
local cmd = vim.cmd

-- source basic configs from vim
cmd("source " .. fn.stdpath("config") .. "/basic.vim")
