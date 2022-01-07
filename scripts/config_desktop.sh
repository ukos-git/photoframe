#!/bin/sh

set -e

if test $EUID -eq 0; then
  echo "$0 must be run as normal user."
  exit 1
fi

echo 
read -p "Hide top Panel? [y/N] " prompt
if test "$prompt" == "y"; then
cat <<EOF2 | tee /home/pi/.config/lxpanel/LXDE-pi/panels/panel
Global {
    edge=bottom
    allign=left
    margin=0
    widthtype=percent
    width=100
    height=0
    transparent=1
    tintcolor=#000000
    alpha=0
    autohide=0
    heightwhenhidden=0
    setdocktype=0
    setpartialstrut=0
    usefontcolor=1
    fontsize=10
    fontcolor=#8b8b8b
    usefontsize=0
    background=0
    backgroundfile=
    iconsize=24
}
EOF2
else
  cp -f /etc/xdg/lxpanel/LXDE-pi/panels/panel /home/pi/.config/lxpanel/LXDE-pi/panels/panel
fi
lxpanelctl refresh


echo 
read -p "Disable Screensaver [y/N] " prompt
if test "$prompt" == "y"; then
cat <<EOF | tee /home/pi/.xsessionrc
# turn off default screensaver
xset s off
# turn off default standby, hibernate, ... after n minutes
xset -dpms
EOF
fi
