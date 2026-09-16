--   _  ___   _____ ___ _      _   _  _ ___
--  | || \ \ / / _ \ _ \ |    /_\ | \| |   \
--  | __ |\ V /|  _/   / |__ / _ \| .` | |) |
--  |_||_| |_| |_| |_|_\____/_/ \_\_|\_|___/
--

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/configuring/core/monitors/
hl.monitor({
  output   = "",
  mode     = "2560x1440@60",
  position = "auto",
  scale    = 1,
})


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/configuring/core/autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function ()
  hl.exec_cmd("hyprctl setcursor Adwaita 24")
  hl.exec_cmd("noctalia")
  hl.exec_cmd("spice-vdagent")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/configuring/core/environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/configuring/core/advanced-configuration/permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/configuring/core/config-options/
hl.config({
  general = {
    gaps_in  = 7,
    gaps_out = 14,
    border_size = 1,

    col = {
      active_border   = { colors = {"rgba(8fbcbbee)", "rgba(a3be8cee)"}, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },

    -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false,

    -- Please see https://wiki.hypr.land/configuring/extra/tearing/ before you turn this on
    allow_tearing = false,

    layout = "master",
  },

  decoration = {
    rounding       = 5,
    rounding_power = 2,

    -- Change transparency of focused and unfocused windows
    active_opacity   = 1.0,
    inactive_opacity = 0.9,

    shadow = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = "rgba(1a1a1aee)",
    },

    blur = {
      enabled   = true,
      size      = 3,
      passes    = 3,
      vibrancy  = 0.1696,
    },
  },

  animations = {
    enabled = true,
  },
})

-- Default curves and animations, see https://wiki.hypr.land/configuring/core/animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = false })
hl.animation({ leaf = "workspacesIn",  enabled = false })
hl.animation({ leaf = "workspacesOut", enabled = false })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- Ref https://wiki.hypr.land/configuring/core/rules/workspace-rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/configuring/layouts/dwindle-layout/ for more
hl.config({
  dwindle = {
    preserve_split = true, -- You probably want this
  },
})

-- See https://wiki.hypr.land/configuring/layouts/master-layout/ for more
hl.config({
  master = {
    new_status = "slave",
  },
})

-- See https://wiki.hypr.land/configuring/layouts/scrolling-layout/ for more
hl.config({
  scrolling = {
    fullscreen_on_one_column = true,
    focus_fit_method = 0,
    column_width = 0.99,
  },
})

----------------
----  MISC  ----
----------------

hl.config({
  misc = {
    force_default_wallpaper = 0,     -- Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
  },
})


---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout  = "us",
    kb_variant = "",
    kb_model   = "",
    kb_options = "",
    kb_rules   = "",

    repeat_rate = 50,
    repeat_delay = 300,
    follow_mouse = 1,

    sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

    touchpad = {
      natural_scroll = true,
    },
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/configuring/core/devices/ for more
hl.device({
  name        = "epic-mouse-v1",
  sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local ipc = "noctalia msg"

-- Example binds, see https://wiki.hypr.land/configuring/core/binds/ for more
hl.bind(mainMod .. " + CTRL + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ toggle = true }))
hl.bind(mainMod .. " + T", hl.dsp.window.pin())

-- Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("MESA_LOADER_DRIVER_OVERRIDE=llvmpipe ghostty"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(ipc .. " panel-toggle launcher"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(ipc .. " panel-toggle clipboard"))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd(ipc .. " panel-toggle launcher \"/emo\""))
hl.bind(mainMod .. " + COMMA", hl.dsp.exec_cmd(ipc .. " settings-toggle"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd(ipc .. " panel-toggle session"))
hl.bind("XF86PowerOff", hl.dsp.exec_cmd(ipc .. " panel-toggle session"))

-- Screen brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(ipc .. " brightness-up"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness-down"), { locked = true, repeating = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume-up"),      { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume-down"),    { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(ipc .. " volume-mute"),    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(ipc .. " mic-mute"),       { locked = true, repeating = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd(ipc .. " media next"),     { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd(ipc .. " media previous"), { locked = true })
hl.bind("XF86AudioPause",       hl.dsp.exec_cmd(ipc .. " media toggle"),   { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd(ipc .. " media toggle"),   { locked = true })

-- Set layout
local setLayoutForCurrWorkspace = function(layout)
  local ws = hl.get_active_special_workspace() or hl.get_active_workspace()
  if not ws then return end

  hl.workspace_rule({
    workspace = ws.special and ws.name or tostring(ws.id),
    layout = layout,
  })
end
hl.bind(mainMod .. " + W", function() setLayoutForCurrWorkspace("scrolling") end)
hl.bind(mainMod .. " + S", function() setLayoutForCurrWorkspace("master") end)

-- Move focus with mainMod + HJKL
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Swap windows
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))

-- Resize windows
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -10, y = 0,   relative = true }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0,   y = -10, relative = true }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }))

-- Switch workspaces with mainMod + [1-5]
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))

-- Move active window to a workspace with mainMod + SHIFT + [1-5]
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/configuring/core/rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name  = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name  = "fix-xwayland-drags",
  match = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },

  no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move  = "20 monitor_h-120",
  float = true,
})
