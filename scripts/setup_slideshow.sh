#!/bin/sh

set -e

if test $EUID -eq 0; then
  echo "$0 must be run as normal user."
  exit 1
fi

# pipresents config
mkdir -p /home/pi/app/photoframe/media
if ! [ -e /home/pi/app/photoframe/media/meta.yml ]; then
  touch /home/pi/app/photoframe/media/meta.yml
fi

# prepare auto start
mkdir -p /home/pi/.config/autostart
rsync /home/pi/app/photoframe/scripts/photoframe.desktop /home/pi/.config/autostart/
