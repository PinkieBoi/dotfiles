#!/bin/bash

function run {
    if ! pgrep "$1"; then
        "$@" &
    fi
}

# KDE / Qt applications
export QT_QPA_PLATFORMTHEME=qt6ct

# DBUS activation
dbus-update-activation-environment --all

xfsettingsd &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/kdeconnectd &
picom -b --config "$HOME"/.config/picom.conf
run dunst &
run xfce4-power-manager &
run nm-applet &
run kdeconnect-indicator &
run pamac-tray &
run variety &
run blueman-applet &
run pasystray &
run mullvad-vpn
