--
-- language.lua
-- language widget
--

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local helpers = require("helpers")
local keys = require("keys")

-- ========================================
-- Config
-- ========================================

-- icons path
local icons_path = beautiful.icons_path .. "language/"


-- ========================================
-- Definition
-- ========================================

-- define buttons
local buttons = function (screen)
  return gears.table.join(
    awful.button(
      {}, keys.leftclick,
      helpers.switch_language
    ),
    awful.button(
      {}, keys.rightclick,
      function() awful.spawn("ibus-setup") end
    )
  )
end


-- update language icon
local update_language_icon = function (widget, language)
  widget.image = icons_path .. language .. ".svg"

  widget.tooltip.text = language == "unknown"
    and "Keyboard layout unknown"
    or  "Keyboard layout is set to " .. language
end


-- create widget instance
local create_widget = function (screen)
  local widget = wibox.widget {
    image = icons_path .. "unknown.svg",
    widget = wibox.widget.imagebox,
  }
  awesome.connect_signal("daemon::language", function (...)
    update_language_icon(widget, ...)
  end)

  local container = require("widgets.clickable_container")(widget)
  container:buttons(buttons(screen))

  widget.tooltip = require("widgets.tooltip")({ container })
  widget.tooltip.text = "Keyboard layout unknown"

  return container
end

return create_widget
