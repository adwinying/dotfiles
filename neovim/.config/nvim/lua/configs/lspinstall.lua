local present, _ = pcall(require, "lspinstall")
if not present then return end

-- don't replace the / with a . in the require calls
-- https://github.com/kabouzeid/nvim-lspinstall/issues/14
local util = require("lspinstall/util")
local servers = require("lspinstall/servers")

-- define volar custom script
local volar_config = util.extract_config("volar")
volar_config.default_config.cmd[1] = "./node_modules/.bin/volar-server"

servers.volar = vim.tbl_extend('error', volar_config, {
  install_script = [[
  ! test -f package.json && npm init -y --scope=lspinstall || true
  npm install @volar/server@latest eslint_d
  ]]
})

-- define emmet custom script
local emmet_config = util.extract_config("emmet_ls")
emmet_config.default_config.cmd[1] = "./node_modules/.bin/emmet-ls"

servers.emmet = vim.tbl_extend('error', emmet_config, {
  install_script = [[
  ! test -f package.json && npm init -y --scope=lspinstall || true
  npm install emmet-ls
  ]]
})
