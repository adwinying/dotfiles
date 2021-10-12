--
-- wm.lua
-- Window manager related config
--

local config = require("configs").wm

local command_list = {
  display = {
    "focus",
  },
  space = {
    "focus",
    "create",
    "destroy",
    "move",
    "swap",
    "display",
    "balance",
    "mirror",
    "rotate",
    "padding",
    "gap",
    "toggle",
    "layout",
    "label",
  },
  window = {
    "focus",
    "swap",
    "warp",
    "stack",
    "insert",
    "grid",
    "move",
    "resize",
    "move",
    "ratio",
    "toggle",
    "layer",
    "opacity",
    "display",
    "space",
    "minimize",
    "deminimize",
    "close",
  },
  query = {
    "displays",
    "spaces",
    "windows",
  },
  rule = {
    "add",
    "remove",
    "list",
  },
  signal = {
    "add",
    "remove",
    "list",
  },
}

local wm = {}

-- =============================================================================
-- APIs
-- =============================================================================

wm.execute_cmd = function (cmd)
  print(string.format("executing: %s %s", config.yabai_path, cmd))

  return hs.execute(string.format("%s %s", config.yabai_path, cmd))
end

wm.send_message = function (cmd)
  return wm.execute_cmd("-m " .. cmd)
end

wm.api = {}
wm.api.config = function (setting)
  return wm.send_message("config " .. setting)
end
for module, commands in pairs(command_list) do
  for _, command in ipairs(commands) do
    if wm.api[module] == nil then
      wm.api[module] = {}
    end

    if module == "display" or module == "space" or module == "window" then
      wm.api[module][command] = function (sel, args)
        return wm.send_message(string.format(
          "%s %s --%s %s",
          module,
          sel or "",
          command,
          args or ""
        ))
      end
    else
      wm.api[module][command] = function (args)
        return wm.send_message(string.format(
          "%s --%s %s",
          module,
          command,
          args or ""
        ))
      end
    end
  end
end


-- =============================================================================
-- Config
-- =============================================================================

wm.get_current_layout = function ()
  return wm.api.config("--space mouse layout"):gsub("\n", "")
end

wm.get_current_display = function ()
  local json = wm.api.query.displays("--display")

  return hs.json.decode(json)
end

wm.get_current_space = function ()
  local json = wm.api.query.spaces("--space")

  return hs.json.decode(json)
end

wm.get_current_window = function ()
  local json = wm.api.query.windows("--window")

  return hs.json.decode(json)
end


-- =============================================================================
-- Display
-- =============================================================================


-- =============================================================================
-- Space
-- =============================================================================


-- =============================================================================
-- Window
-- =============================================================================

wm.move_window = function (window_sel)
  if wm.get_current_window().floating == 0 then
    return wm.api.window.swap(nil, window_sel)
  end

  local dir_map = {
    north = string.format("rel:0:%s", -config.move_step),
    south = string.format("rel:0:%s", config.move_step),
    west  = string.format("rel:%s:0", -config.move_step),
    east  = string.format("rel:%s:0", config.move_step),
  }

  return wm.api.window.move(nil, dir_map[window_sel])
end

wm.resize_window = function (window_sel)
  local dir_map = {
    north = string.format("bottom:0:%s", -config.resize_step),
    south = string.format("bottom:0:%s", config.resize_step),
    west  = string.format("right:%s:0", -config.resize_step),
    east  = string.format("right:%s:0", config.resize_step),
  }

  return wm.api.window.resize(nil, dir_map[window_sel])
end

return wm
