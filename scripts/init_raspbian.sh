#!/bin/sh

set -e

echo "DO NOT use $0 as part of a regular update process."
read -p "continue [y/N] " prompt
test "$prompt" == "y"

if test $EUID -ne 0; then
  echo "$0 must be run as root."
  exit 1
fi

apt update

echo 
read -p "update to latest raspbian [y/N] " prompt
if test "$prompt" == "y"; then
  apt full-upgrade
  apt clean
fi

echo 
read -p "update firmware [y/N] " prompt
if test "$prompt" == "y"; then
  apt install -y rpi-update
  rpi-update
fi


echo 
read -p "install required packages [y/N] " prompt
if test "$prompt" == "y"; then
  apt install -y \
    fonts-noto-color-emoji \
    getmail6 \
    git \
    imagemagick \
    lightdm \
    lxde-core \
    lxterminal \
    lxappearance \
    maildir-utils \
    python3-opencv \
    python3-pil \
    python3-pil.imagetk \
    python3-sklearn \
    python3-yaml \
    raspberrypi-ui-mods \
    raspi-config \
    rpi-chromium-mods \
    unclutter \
    x11-xserver-utils
  apt remove xscreensaver
fi

apt clean

echo 
read -p "restart pi [y/N] " prompt
if test "$prompt" == "y"; then
  shutdown -r now
fi
