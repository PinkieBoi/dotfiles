--[[              __             __             __
     ____ ___  __/ /_____  _____/ /_____ ______/ /_
    / __ `/ / / / __/ __ \/ ___/ __/ __ `/ ___/ __/
   / /_/ / /_/ / /_/ /_/ (__  ) /_/ /_/ / /  / /_
   \__,_/\__,_/\__/\____/____/\__/\__,_/_/   \__/
 
]]
-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function()
	hl.exec_cmd("$HOME/.config/hypr/scripts/xdgDesktopPortal.sh")
	hl.exec_cmd("systemctl --user start hyprpolkitagent &")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("gnome-keyring-daemon --start")
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("/usr/bin/kdeconnectd &")
	hl.exec_cmd("noctalia")
	hl.exec_cmd("awww-daemon && waypaper --random")
	hl.exec_cmd("kdeconnect-indicator &")
	hl.exec_cmd("nm-applet --indicator &")
	hl.exec_cmd("clipse -listen")
	hl.exec_cmd("xhost +SI:localuser:root")
end)
