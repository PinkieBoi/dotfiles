#!/bin/bash

function run {
  if ! pgrep -x $(basename $1 | head -c 15) 1>/dev/null;
  then
    $@&
  fi
}

# DBUS activation
dbus-update-activation-environment --all

# keyboard layout
setxkbmap us

xfsettingsd &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/kdeconnectd &
picom --config $HOME/.config/picom.conf &
numlockx on &
run variety &
run nm-applet &
run pamac-tray &
run xfce4-power-manager &
gnome-keyring-daemon --start
run volumeicon &
run blueman-applet &
# blueberry-tray &
run dunst &
run kdeconnect-indicator &
run protonmail-bridge &

