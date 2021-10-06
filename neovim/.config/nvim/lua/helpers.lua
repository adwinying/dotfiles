local M = {}

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin, timer)
  if not plugin then return end

  vim.defer_fn(
    function() require("packer").loader(plugin) end,
    timer or 0
  )
end

-- map keybindings
M.map = function(mode, keys, cmd, opt)
  local options = { noremap = true, silent = true }

  if opt then options = vim.tbl_extend("force", options, opt) end

  -- all valid modes allowed for mappings
  -- :h map-modes
  local valid_modes = {
    [""] = true,
    ["n"] = true,
    ["v"] = true,
    ["s"] = true,
    ["x"] = true,
    ["o"] = true,
    ["!"] = true,
    ["i"] = true,
    ["l"] = true,
    ["c"] = true,
    ["t"] = true,
  }

  -- helper function for M.map
  -- can provide multiple modes and keys
  local function map_wrapper(mode, lhs, rhs, options)
    if type(lhs) == "table" then
      for _, key in ipairs(lhs) do map_wrapper(mode, key, rhs, options) end
      return
    end

    if type(mode) == "table" then
      for _, m in ipairs(mode) do map_wrapper(m, lhs, rhs, options) end
      return
    end

    if not valid_modes[mode] or not lhs or not rhs then
      mode, lhs, rhs = mode or "", lhs or "", rhs or ""
      print(string.format(
        "Cannot set mapping [ mode = '%s' | key = '%s' | cmd = '%s' ]",
        mode, lhs, rhs
      ))
    end

    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end

  map_wrapper(mode, keys, cmd, options)
end

return M
