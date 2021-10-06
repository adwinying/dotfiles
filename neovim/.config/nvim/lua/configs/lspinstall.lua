local present, _ = pcall(require, "lspinstall")
if not present then return end

-- don't replace the / with a . in the require calls
-- https://github.com/kabouzeid/nvim-lspinstall/issues/14
local util = require("lspinstall/util")
local servers = require("lspinstall/servers")

-- define volar custom script
local config = util.extract_config("volar")
config.default_config.cmd[1] = "./node_modules/.bin/volar-server"

servers.volar = vim.tbl_extend('error', config, {
  install_script = [[
  ! test -f package.json && npm init -y --scope=lspinstall || true
  npm install @volar/server@latest
  ]]
})
