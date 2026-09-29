--[[
    ___  ____ _   __   _   ______ ___________
   / _ \/ __ \ | / /  | | / / __ `/ ___/ ___/
  /  __/ / / / |/ /   | |/ / /_/ / /  (__  )
  \___/_/ /_/|___/    |___/\__,_/_/  /____/
  https://wiki.hyprland.org/Configuring/Environment-variables/

--]]

-- Cursor
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "hyprcursor_Dracula")

-- Toolkit
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG Specs
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_TYPE", "wayland")

-- Qt Vars
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
-- hyprland-qt-support
hl.env("QT_QUICK_CONTROLS_STYLE", "org.hyprland.style")

-- Logging
hl.env("HYPRLAND_TRACE", "1")
hl.env("AQ_TRACE", "1")

-- xwayland apps scale fix (useful if you are use monitor scaling).
-- Set same value if you use scaling in Monitors.conf
-- see https://wiki.hyprland.org/Configuring/XWayland/
hl.env("GDK_SCALE", "1")
hl.env("QT_SCALE_FACTOR", "1")

-- Misc.
hl.env("SDL_VIDEODRIVER", "wayland")

-- Electron
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- firefox
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- GPU
hl.env("LIBVA_DRIVER_NAME", "radeonsi")
hl.env("GDM_BACKEND", "amd")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "mesa")
