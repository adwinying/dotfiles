--
-- helpers.lua
-- Helper functions
--

local configs = require("configs")

local M = {}

-- =============================================================================
-- Windows
-- =============================================================================

-- get active window and run callback if exists
M.get_active_window = function (callback)
  local win = hs.window.frontmostWindow()

  if not win then return end

  callback(win)
end

-- focus window
M.focus_window = function (direction)
  local direction_map = {
    up    = "North",
    down  = "South",
    left  = "West",
    right = "East",
  }

  M.get_active_window(function (win)
    win["focusWindow" .. direction_map[direction]](win)
  end)
end

-- move window
M.move_window = function (direction)
  local direction_map = {
    up    = "north",
    down  = "south",
    left  = "west",
    right = "east",
  }

  M.get_active_window(function (win)
    if Hhtwm.getLayout() == "floating" or Hhtwm.isFloating(win) then
      local rect = win:frame()

      if direction == "up" then
        rect.y = rect.y - configs.wm.resize_step
      elseif direction == "down" then
        rect.y = rect.y + configs.wm.resize_step
      elseif direction == "left" then
        rect.x = rect.x - configs.wm.resize_step
      elseif direction == "right" then
        rect.x = rect.x + configs.wm.resize_step
      end

      win:setFrameInScreenBounds(rect)
    else
      Hhtwm.swapInDirection(win, direction_map[direction])
    end
  end)
end

-- resize window
M.resize_window = function (direction)
  local resize_map = {
    up    = "shorter",
    down  = "taller",
    left  = "thinner",
    right = "wider",
  }

  M.get_active_window(function (win)
    if Hhtwm.getLayout() == "floating" or Hhtwm.isFloating(win) then
      local rect = win:frame()

      if direction == "up" then
        rect.y2 = rect.y2 - configs.wm.resize_step
      elseif direction == "down" then
        rect.y2 = rect.y2 + configs.wm.resize_step
      elseif direction == "left" then
        rect.x2 = rect.x2 - configs.wm.resize_step
      elseif direction == "right" then
        rect.x2 = rect.x2 + configs.wm.resize_step
      end

      win:setFrameInScreenBounds(rect)
    else
      Hhtwm.resizeLayout(resize_map[direction])
    end
  end)
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
