local present, lspinstall = pcall(require, "lspinstall")

if not present then return end

-- servers to install
local servers = {
  "volar",
  "php",
  "typescript",
  "lua",
}

local install_servers = function ()
  for _, server in ipairs(servers) do
    lspinstall.install_server(server)
  end
end

install_servers()