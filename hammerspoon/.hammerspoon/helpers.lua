--
-- helpers.lua
-- Helper functions
--

local configs = require("configs")

local M = {}

-- =============================================================================
-- Tables
-- =============================================================================

-- sort table by keys
M.sort_by_keys = function (t, f)
  local keys = {}

  for n in pairs(t) do table.insert(keys, n) end

  table.sort(keys, f)

  local i = 0
  local iter = function ()
    i = i + 1
    if keys[i] == nil then
      return nil
    else
      return keys[i], t[keys[i]]
    end
  end

  return iter
end

-- =============================================================================
-- Windows
-- =============================================================================

-- get active window and run callback if exists
M.get_active_window = function (callback)
  local win = hs.window.frontmostWindow()

  if not win then return end

  callback(win)
end


-- =============================================================================
-- Libraries
-- =============================================================================

-- download external libraries
M.download_library = function (rel_file_path, url)
  local rel_file_dir, filename = rel_file_path:match("(.+)/(.+)")

  if rel_file_dir == nil or filename == nil then
    rel_file_dir = ""
    filename = rel_file_path
  end

  local lib_path = configs.paths.library
  local dir_path = lib_path .. "/" .. rel_file_dir
  local file_path = dir_path .. "/" .. filename

  hs.notify.new({
    title = "Downloading library",
    informativeText = "Downloading to " .. file_path,
  }):send()

  local _, success = hs.execute(string.format(
    'mkdir -p %s && curl -o %s %s',
    dir_path,
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
