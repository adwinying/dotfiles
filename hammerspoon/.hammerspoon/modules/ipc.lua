--
-- ipc.lua
-- ipc config
--

if not hs.ipc.cliStatus() then
  hs.ipc.cliInstall()
end

require("hs.ipc")
