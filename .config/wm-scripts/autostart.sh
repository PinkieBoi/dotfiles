#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

# Keyboard layout
setxkbmap gb

#starting utility applications at boot time
xfsettingsd &
numlockx on &
xfce4-power-manager &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
picom --config $HOME/.config/wm-scripts/picom.conf &
nm-applet &
variety &
pamac-tray &
blueman-applet &
kdeconnect-indicator &
nextcloud &
optimus-manager-qt &
