--
-- wm.lua
-- Window manager related keybindings
--

local spaces = require("hs._asm.undocumented.spaces")
local helpers = require("helpers")
local hyper = require("modules.hyper")
local wm = require("modules.wm")

-- =============================================================================
-- Layouts
-- =============================================================================

-- select floating layout
hyper:bind({ "shift" }, "s", function ()
  wm.api.config("--space mouse layout float")
  Layouts:update()
end)

-- select bsp layout
hyper:bind({}, "s", function ()
  wm.api.config("--space mouse layout bsp")
  Layouts:update()
end)

-- select stack layout
hyper:bind({}, "w", function ()
  wm.api.config("--space mouse layout stack")
  Layouts:update()
end)


-- =============================================================================
-- Display navigation
-- =============================================================================

-- move to display #
for i = 1, 9 do
  hyper:bind({ "cmd" }, tostring(i), function ()
    wm.api.display.focus(nil, i)
  end)
end


-- =============================================================================
-- Space navigation
-- =============================================================================

-- move to space #
for i = 1, 9 do
  hyper:bind({}, tostring(i), function ()
    wm.api.space.focus(nil, i)
  end)
end


-- =============================================================================
-- Window navigation
-- =============================================================================

-- move to left window
hyper:bind({}, "h", function ()
  wm.api.window.focus(nil, "west")
end)

-- move to bottom window
-- cycle next windows in monocle mode
hyper:bind({}, "j", function ()
  if wm.get_current_layout() == "stack" then
    wm.api.window.focus(nil, "stack.next")
  else
    wm.api.window.focus(nil, "south")
  end
end)

-- move to top window
-- cycle previous windows in monocle mode
hyper:bind({}, "k", function ()
  if wm.get_current_layout() == "stack" then
    wm.api.window.focus(nil, "stack.prev")
  else
    wm.api.window.focus(nil, "north")
  end
end)

-- move to right window
hyper:bind({}, "l", function ()
  wm.api.window.focus(nil, "east")
end)


-- =============================================================================
-- Window move
-- =============================================================================

-- move window left
hyper:bind({ "shift" }, "h", function ()
  wm.move_window("west")
end)

-- move window down
hyper:bind({ "shift" }, "j", function ()
  wm.move_window("south")
end)

-- move window up
hyper:bind({ "shift" }, "k", function ()
  wm.move_window("north")
end)

-- move window right
hyper:bind({ "shift" }, "l", function ()
  wm.move_window("east")
end)

-- move window to left screen
hyper:bind({ "cmd", "shift" }, "h", function ()
  wm.api.window.display(nil, "west")
end)

-- move window to bottom screen
hyper:bind({ "cmd", "shift" }, "j", function ()
  wm.api.window.display(nil, "south")
end)

-- move window to top screen
hyper:bind({ "cmd", "shift" }, "k", function ()
  wm.api.window.display(nil, "north")
end)

-- move window to right screen
hyper:bind({ "cmd", "shift" }, "l", function ()
  wm.api.window.display(nil, "east")
end)


-- =============================================================================
-- Window resize
-- =============================================================================

-- resize window left
hyper:bind({ "ctrl" }, "h", function ()
  wm.resize_window("west")
end)

--  resize window down
hyper:bind({ "ctrl" }, "j", function ()
  wm.resize_window("south")
end)

--  resize window up
hyper:bind({ "ctrl" }, "k", function ()
  wm.resize_window("north")
end)

--  resize window right
hyper:bind({ "ctrl" }, "l", function ()
  wm.resize_window("east")
end)


-- =============================================================================
-- Window management
-- =============================================================================

-- Toggle float
hyper:bind({ "ctrl" }, "space", function ()
  wm.api.window.toggle(nil, "float")
end)

-- Toggle full screen
hyper:bind({}, "f", function ()
  wm.api.window.toggle(nil, "native-fullscreen")
end)

-- Toggle sticky
hyper:bind({}, "t", function ()
  wm.api.window.toggle(nil, "sticky")
end)

-- Minimize window
hyper:bind({}, "n", function ()
  wm.api.window.minimize()
  helpers.get_active_window(function (win) win:focus() end)
end)

-- Restore minimized windows
hyper:bind({ "shift" }, "n", function ()
  for _, win in ipairs(spaces.allWindowsForSpace(spaces.activeSpace())) do
    win:unminimize()
  end
  helpers.get_active_window(function (win) win:focus() end)
end)

-- Close
hyper:bind({ "shift" }, "c", function ()
  wm.api.window.close()
end)

-- Move window to space #
for i = 1, 9 do
  hyper:bind({ "shift" }, tostring(i), function ()
    wm.api.window.space(nil, i)
  end)
end
