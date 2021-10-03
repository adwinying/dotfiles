--
-- floating_terminal.lua
-- floating terminal component
--

local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi


-- ========================================
-- Config
-- ========================================

-- terminal client name argument
local terminal_name_arg = "--class "

-- terminal client instance name
local client_name = "FloatingTerminal"

-- terminal client placement
local client_placement = awful.placement.right
  + awful.placement.maximize_vertically

-- terminal client width
local client_width = dpi(600)

-- terminal client height
local client_height = dpi(500)


-- ========================================
-- Logic
-- ========================================

-- Define a new class
local FloatingTerminal = {}
FloatingTerminal.__index = FloatingTerminal


-- Class constructor
function FloatingTerminal:new ()
  -- create new class instance
  local floating_terminal = {}
  setmetatable(floating_terminal, FloatingTerminal)

  -- set configs
  floating_terminal.app     = Apps.terminal
  floating_terminal.arg     = terminal_name_arg .. client_name
  floating_terminal.name    = client_name
  floating_terminal.visible = false

  floating_terminal:init_signals()

  return floating_terminal
end


-- get floating terminal instance
function FloatingTerminal:get_instance ()
  local matcher = function (c)
    return awful.rules.match(c, { instance = self.name })
  end

  -- First, we locate the terminal
  for c in awful.client.iterate(matcher) do
    return c
  end

  -- If not found return nil
  return nil
end


-- spawn the floating terminal
function FloatingTerminal:spawn ()
  awful.spawn(self.app .. " " .. self.arg)
end


-- show the floating terminal
function FloatingTerminal:show ()
  local c = self:get_instance()

  if c == nil then return self:spawn() end

  -- This is not a normal window, don't apply any specific keyboard stuff
  c:buttons({})
  c:keys({})

  -- Set client attrs
  c.honor_padding = false
  c.honor_workarea = false
  c.size_hints_honor = false
  c.hidden = false
  c.floating = true
  c.sticky = true
  c.ontop = true
  c.above = true

  -- Focus client
  c:raise()
  client.focus = c

  -- Resize
  c:geometry({ width = client_width, height = client_height })
  client_placement(c)

  self.visible = true
end


-- hide the floating terminal
function FloatingTerminal:hide ()
  local c = self:get_instance()

  if c ~= nil then c.hidden = true end

  self.visible = false
end


-- Toggle the floating terminal
function FloatingTerminal:toggle()
  if self.visible then self:hide() else self:show() end
end


-- Init signals
function FloatingTerminal:init_signals ()
  -- detect when floating terminal is spawned
  client.connect_signal("manage", function(c)
    if c.instance == self.name then self:show() end
  end)

  -- detect when floating terminal is killed
  client.connect_signal("unmanage", function(c)
    if c.instance == self.name then self.visible = false end
  end)

  -- show the floating terminal when signal is broadcasted
  awesome.connect_signal("floating_terminal::show", function()
    self:show()
  end)

  -- hide the floating terminal when signal is broadcasted
  awesome.connect_signal("floating_terminal::hide", function()
    self:hide()
  end)

  -- toggle the floating terminal when signal is broadcasted
  awesome.connect_signal("floating_terminal::toggle", function()
    self:toggle()
  end)
end


-- ========================================
-- Initialization
-- ========================================

FloatingTerminal:new()
