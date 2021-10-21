--
-- cheatsheet.lua
-- cheatsheet module
--

local helpers = require("helpers")
local hyper = require("modules.hyper")

Cheatsheet = {}

Cheatsheet.template = [[
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Cheatsheet</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style type="text/css">
      body {
        padding: 0.5rem;
        font-family: "HackGen Console", monospace;
        font-size: 16px;
        background-color: rgba(0, 0, 0, 0.85);
        color: #eceff4;
      }
      .main-wrapper {
        width: 100vw;
        height: 100vh;
        display: flex;
        flex-direction: column;
        flex-wrap: wrap;
        font-size: 0.85rem;
      }
      .map-group {
        width: 17rem;
        padding-bottom: 0.8rem;
      }
      .map-group-name {
        margin-bottom: 0.35rem;
        color: #8fbcbb;
        font-weight: bold;
      }
      .map-item {
        display: flex;
      }
      .map-keybinding {
        width: 5rem;
        font-family: "Lucida Grande", sans-serif;
      }
      .map-description {
        flex: 1;
      }
    </style>
  </head>
  <body>
    <div class="main-wrapper">
      %s
    </div>
  </body>
</html>
]]

Cheatsheet.descriptions = {
  ["⇧R"]     = { group = "Hammerspoon", description = "Reload configs" },
  ["⇧T"]     = { group = "Hammerspoon", description = "Toggle console" },

  ["TAB"]    = { group = "Modules", description = "Toggle expose" },
  ["⇧/"]     = { group = "Modules", description = "Toggle cheatsheet" },
  ["`"]      = { group = "Modules", description = "Toggle floating terminal" },

  ["RETURN"] = { group = "Apps", description = "Launch or focus terminal" },
  ["B"]      = { group = "Apps", description = "Launch or focus browser" },

  ["⇧S"]     = { group = "WM:Layout", description = "Set current space to floating layout" },
  ["S"]      = { group = "WM:Layout", description = "Set current space to bsp layout" },
  ["W"]      = { group = "WM:Layout", description = "Set current space to stack layout" },

  ["⌘1"]     = { group = "WM:Display", description = "Focus display #1" },
  ["⌘2"]     = { group = "WM:Display", description = "Focus display #2" },
  ["⌘3"]     = { group = "WM:Display", description = "Focus display #3" },
  ["⌘4"]     = { group = "WM:Display", description = "Focus display #4" },
  ["⌘5"]     = { group = "WM:Display", description = "Focus display #5" },
  ["⌘6"]     = { group = "WM:Display", description = "Focus display #6" },
  ["⌘7"]     = { group = "WM:Display", description = "Focus display #7" },
  ["⌘8"]     = { group = "WM:Display", description = "Focus display #8" },
  ["⌘9"]     = { group = "WM:Display", description = "Focus display #9" },

  ["1"]      = { group = "WM:Space", description = "Focus space #1" },
  ["2"]      = { group = "WM:Space", description = "Focus space #2" },
  ["3"]      = { group = "WM:Space", description = "Focus space #3" },
  ["4"]      = { group = "WM:Space", description = "Focus space #4" },
  ["5"]      = { group = "WM:Space", description = "Focus space #5" },
  ["6"]      = { group = "WM:Space", description = "Focus space #6" },
  ["7"]      = { group = "WM:Space", description = "Focus space #7" },
  ["8"]      = { group = "WM:Space", description = "Focus space #8" },
  ["9"]      = { group = "WM:Space", description = "Focus space #9" },

  ["⇧1"]     = { group = "WM:Window", description = "Move window to space #1" },
  ["⇧2"]     = { group = "WM:Window", description = "Move window to space #2" },
  ["⇧3"]     = { group = "WM:Window", description = "Move window to space #3" },
  ["⇧4"]     = { group = "WM:Window", description = "Move window to space #4" },
  ["⇧5"]     = { group = "WM:Window", description = "Move window to space #5" },
  ["⇧6"]     = { group = "WM:Window", description = "Move window to space #6" },
  ["⇧7"]     = { group = "WM:Window", description = "Move window to space #7" },
  ["⇧8"]     = { group = "WM:Window", description = "Move window to space #8" },
  ["⇧9"]     = { group = "WM:Window", description = "Move window to space #9" },

  ["H"]      = { group = "WM:Window 2", description = "Focus left window" },
  ["J"]      = { group = "WM:Window 2", description = "Focus bottom/next window" },
  ["K"]      = { group = "WM:Window 2", description = "Focus top/previous window" },
  ["L"]      = { group = "WM:Window 2", description = "Focus right window" },
  ["⇧H"]     = { group = "WM:Window 2", description = "Swap with left window" },
  ["⇧J"]     = { group = "WM:Window 2", description = "Swap with bottom window" },
  ["⇧K"]     = { group = "WM:Window 2", description = "Swap with top window" },
  ["⇧L"]     = { group = "WM:Window 2", description = "Swap with right window" },
  ["⌘⇧H"]    = { group = "WM:Window 2", description = "Move window to left screen" },
  ["⌘⇧J"]    = { group = "WM:Window 2", description = "Move window to bottom screen" },
  ["⌘⇧K"]    = { group = "WM:Window 2", description = "Move window to top screen" },
  ["⌘⇧L"]    = { group = "WM:Window 2", description = "Move window to right screen" },
  ["⌃H"]     = { group = "WM:Window 2", description = "Decrease window width" },
  ["⌃J"]     = { group = "WM:Window 2", description = "Increase window height" },
  ["⌃K"]     = { group = "WM:Window 2", description = "Decrease window width" },
  ["⌃L"]     = { group = "WM:Window 2", description = "Increase window width" },

  ["⌃SPACE"] = { group = "WM:Window 3", description = "Toggle window float" },
  ["F"]      = { group = "WM:Window 3", description = "Toggle window full screen" },
  ["T"]      = { group = "WM:Window 3", description = "Toggle window sticky" },
  ["N"]      = { group = "WM:Window 3", description = "Minimize window" },
  ["⇧N"]     = { group = "WM:Window 3", description = "Restore all minimize windows in current space" },
  ["⇧C"]     = { group = "WM:Window 3", description = "Close window" },
}

Cheatsheet.html = ""
Cheatsheet.groupings = {}
Cheatsheet.is_active = false

function Cheatsheet:generate_groupings ()
  local kbs = hyper.keys
  self.groupings = {}

  for _, kb in ipairs(kbs) do
    local idx  = kb.idx
    local desc = self.descriptions[idx]

    if desc == nil then
      desc = { group = "Unknown" , description = "Unknown keybinding" }
    end

    local group = desc.group

    if self.groupings[group] == nil then
      self.groupings[group] = {}
    end

    self.groupings[group][idx] = desc.description
  end
end

function Cheatsheet:generate_html ()
  local groupings_html = ""

  for group_name, group in helpers.sort_by_keys(self.groupings) do
    local mappings_html = ""

    for keybind, description in helpers.sort_by_keys(group) do
      local symbol = keybind
        :gsub("RETURN", "⏎")
        :gsub("SPACE", "␣")
        :gsub("TAB", "↹")

      mappings_html = mappings_html .. string.format([[
        <div class="map-item">
          <div class="map-keybinding">%s</div>
          <div class="map-description">%s</div>
        </div>
      ]], "✦" .. symbol, description)
    end

    groupings_html = groupings_html .. string.format([[
      <div class="map-group">
        <div class="map-group-name">%s</div>
        %s
      </div>
    ]], group_name, mappings_html)
  end

  self.html = string.format(self.template, groupings_html)
end

function Cheatsheet:init()
  self.webview = hs.webview.new({ x = 0, y = 0, w = 0, h = 0 })
  self.webview:windowTitle("Cheatsheet")
  self.webview:windowStyle("utility")
  self.webview:transparent(true)
  self.webview:allowGestures(true)
  self.webview:closeOnEscape(true)
  self.webview:allowNewWindows(false)
  self.webview:level(hs.drawing.windowLevels.modalPanel)
  self.webview:behavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
end

function Cheatsheet:show ()
  local cscreen = hs.screen.mainScreen()
  local cres    = cscreen:fullFrame()

  self.webview:frame({
    x = cres.x + cres.w * 0.4 / 2,
    y = cres.y + cres.h * 0.4 / 2,
    w = cres.w * 0.6,
    h = cres.h * 0.6,
  })

  if self.html == "" then
    self:generate_groupings()
    self:generate_html()
  end

  self.webview:html(self.html)
  self.webview:show()
  self.is_active = true
end

function Cheatsheet:hide ()
  self.webview:hide()
  self.is_active = false
end

function Cheatsheet:toggle ()
  if Cheatsheet.is_active then
    Cheatsheet:hide()
  else
    Cheatsheet:show()
  end
end

Cheatsheet:init()
