#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#change your keyboard if you need it
setxkbmap gb

#starting utility applications at boot time
xfsettingsd &
numlockx on &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
picom --config $HOME/.config/qtile/scripts/picom.conf &
variety &
nm-applet &
pamac-tray &
xfce4-power-manager &
blueman-applet &
kdeconnect-indicator &
optimus-manager-qt &
volumeicon &
