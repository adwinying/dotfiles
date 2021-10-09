--
-- helpers.lua
-- Helper functions
--

local configs = require("configs")

local M = {}

-- download external libraries
M.download_library = function (filename, url)
  local lib_path = configs.paths.library
  local file_path = lib_path .. "/" .. filename

  hs.notify.new({
    title = "Downloading library",
    informativeText = "Downloading to " .. file_path,
  }):send()

  local _, success = hs.execute(string.format(
    'mkdir -p %s && curl -o %s %s',
    lib_path,
    file_path,
    url
  ))

  -- If fail then notify user
  if not success then
    hs.notify.new({
      title = "Library download failed",
      informativeText = string.format('Failed to download "%s"', filename),
      autoWithdraw = false,
    }):send()

    return
  end
end

return M
