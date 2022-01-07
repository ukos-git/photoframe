#!/bin/sh

set -e

if test $EUID -ne 0; then
  echo "$0 must be run as root."
  exit 1
fi

PHOTOFRAME_APP=$(cd $(dirname $0)/..; pwd)

echo
echo "copying new theme to plymouth"
rm -rf /usr/share/plymouth/themes/photoframe
if ! [ -e /usr/share/plymouth/themes/photoframe ]; then
  cp -r $PHOTOFRAME_APP/themes/plymouth /usr/share/plymouth/themes/photoframe
  cp -f $PHOTOFRAME_APP/img/logo.png /usr/share/plymouth/themes/photoframe/splash.png
fi
plymouth-set-default-theme -R photoframe

echo 
read -p "Test Boot Splash Screen? [y/N] " prompt
if test "$prompt" == "y"; then
  plymouthd
  plymouth --show-splash
  for i in {0..10}; do
    plymouth --update="Boot Progress ${i}0%"
    sleep 0.5
  done
  plymouth quit
fi

echo
echo "setting boot splash in /boot/cmdline.txt"
ENABLE=0
DISABLE=1
SPLASH=$DISABLE
read -p "Enable Boot Splash Screen? [y/N] " prompt
if test "$prompt" == "y"; then
  SPLASH=$ENABLE
fi
raspi-config nonint do_boot_splash $SPLASH

echo
echo update initramfs
update-initramfs -u -k all

echo
echo finished.
raspi-config nonint do_finish
