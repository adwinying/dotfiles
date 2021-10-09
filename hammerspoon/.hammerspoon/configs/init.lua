--
-- init.lua
-- Configs
--

-- =============================================================================
-- Initialization
-- =============================================================================

local config = require("configs.default")
local custom = require("configs.custom")

-- merge configs
local extend_table = function (...)
  local ret = {}

  for i = 1, select('#', ...) do
    local tbl = select(i, ...)

    for k, v in pairs(tbl) do
      if type(v) == "table" then
        if type(ret[k] or false) == "table" then
          extend_table(ret[k] or {}, tbl[k] or {})
        else
          ret[k] = v
        end
      else
        ret[k] = v
      end
    end
  end

  return ret
end

return extend_table(config, custom)
