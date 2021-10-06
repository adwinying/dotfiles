local M = {}

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin, timer)
  if not plugin then return end

  vim.defer_fn(
    function() require("packer").loader(plugin) end,
    timer or 0
  )
end

return M
