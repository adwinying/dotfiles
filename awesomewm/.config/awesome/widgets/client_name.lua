--
-- client_name.lua
-- focused client name component
--

local wibox = require("wibox")

-- update currently focused client name
local update_widget = function (widget)
  local c = client.focus
  if c ~= nil then
    widget.text = c.name or c.class or ""
  else
    widget.text = ""
  end
end

-- create client_name widget instance
local create_widget = function (screen)
  local widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "",
    valign = "center",
    align = "center",
  }

  client.connect_signal("focus", function (c)
    update_widget(widget)
  end)
  client.connect_signal("unfocus", function (c)
    update_widget(widget)
  end)
  client.connect_signal("property::name", function (c)
    update_widget(widget)
  end)

  return widget
end

return create_widget
