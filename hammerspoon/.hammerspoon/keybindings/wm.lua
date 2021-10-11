--
-- wm.lua
-- Window manager related keybindings
--

local spaces = require("hs._asm.undocumented.spaces")
local helpers = require("helpers")
local hyper = require("modules.hyper")

-- =============================================================================
-- Layouts
-- =============================================================================

-- select floating layout
hyper:bind({ "shift" }, "s", function ()
  Hhtwm.setLayout("floating")
end)

-- select main-left layout
hyper:bind({}, "s", function ()
  Hhtwm.setLayout("main-left")
end)

-- select main-center layout
hyper:bind({ "shift" }, "w", function ()
  Hhtwm.setLayout("main-center")
end)

-- select monocle layout
hyper:bind({}, "w", function ()
  Hhtwm.setLayout("monocle")
end)


-- =============================================================================
-- Space navigation
-- =============================================================================

-- move to space #
for i = 1, 5 do
  hyper:bind({}, tostring(i), function ()
    hs.eventtap.keyStroke({ "ctrl" }, tostring(i))
  end)
end


-- =============================================================================
-- Window navigation
-- =============================================================================

-- move to left window
hyper:bind({}, "h", function ()
  helpers.focus_window("left")
end)

-- move to bottom window
-- cycle next windows in monocle mode
hyper:bind({}, "j", function ()
  if Hhtwm.getLayout() == "monocle" then
    local filter = hs.window.filter.new():setCurrentSpace(true)
    hs.window.switcher.new(filter):next()
  else
    helpers.focus_window("down")
  end
end)

-- move to top window
-- cycle previous windows in monocle mode
hyper:bind({}, "k", function ()
  if Hhtwm.getLayout() == "monocle" then
    local filter = hs.window.filter.new():setCurrentSpace(true)
    hs.window.switcher.new(filter):previous()
  else
    helpers.focus_window("up")
  end
end)

-- move to right window
hyper:bind({}, "l", function ()
  helpers.focus_window("right")
end)


-- =============================================================================
-- Window move
-- =============================================================================

-- move window left
hyper:bind({ "shift" }, "h", function ()
  helpers.move_window("left")
end)

-- move window down
hyper:bind({ "shift" }, "j", function ()
  helpers.move_window("down")
end)

-- move window up
hyper:bind({ "shift" }, "k", function ()
  helpers.move_window("up")
end)

-- move window right
hyper:bind({ "shift" }, "l", function ()
  helpers.move_window("right")
end)

-- move window to left screen
hyper:bind({ "cmd", "shift" }, "h", function ()
  helpers.get_active_window(function (win)
    win:moveOneScreenWest()
  end)
end)

-- move window to bottom screen
hyper:bind({ "cmd", "shift" }, "j", function ()
  helpers.get_active_window(function (win)
    win:moveOneScreenSouth()
  end)
end)

-- move window to top screen
hyper:bind({ "cmd", "shift" }, "k", function ()
  helpers.get_active_window(function (win)
    win:moveOneScreenNorth()
  end)
end)

-- move window to right screen
hyper:bind({ "cmd", "shift" }, "l", function ()
  helpers.get_active_window(function (win)
    win:moveOneScreenEast()
  end)
end)


-- =============================================================================
-- Window resize
-- =============================================================================

-- resize window left
hyper:bind({ "ctrl" }, "h", function ()
  helpers.resize_window("left")
end)

--  resize window down
hyper:bind({ "ctrl" }, "j", function ()
  helpers.resize_window("down")
end)

--  resize window up
hyper:bind({ "ctrl" }, "k", function ()
  helpers.resize_window("up")
end)

--  resize window right
hyper:bind({ "ctrl" }, "l", function ()
  helpers.resize_window("right")
end)


-- =============================================================================
-- Window management
-- =============================================================================

-- Toggle float
hyper:bind({ "ctrl" }, "space", function ()
  helpers.get_active_window(function (win)
    Hhtwm.toggleFloat(win)

    if Hhtwm.isFloating(win) then
      hs.grid.center(win)
    end
  end)
end)

-- Toggle full screen
hyper:bind({}, "f", function ()
  helpers.get_active_window(function (win)
    win:toggleFullScreen()
  end)
end)

-- Minimize window
hyper:bind({}, "n", function ()
  helpers.get_active_window(function (win)
    win:minimize()

    -- focus next available window
    helpers.get_active_window(function (nextwin)
      nextwin:focus()
    end)
  end)
end)

-- Restore minimized windows
hyper:bind({ "shift" }, "n", function ()
  for _, win in ipairs(spaces.allWindowsForSpace(spaces.activeSpace())) do
    win:unminimize()
  end
end)

-- Close
hyper:bind({ "shift" }, "c", function ()
  helpers.get_active_window(function (win)
    win:close()
  end)
end)

-- Move window to space #
for i = 1, 9 do
  hyper:bind({ "shift" }, tostring(i), function ()
    helpers.get_active_window(function (win)
      Hhtwm.throwToSpace(win, i)
    end)
  end)
end
