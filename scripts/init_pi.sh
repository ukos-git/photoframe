#!/bin/sh

set -e

if test $EUID -ne 0; then
  echo "$0 must be run as root."
  exit 1
fi

echo
echo use raspi-config bash script
if ! command -v raspi-config 2>/dev/null; then
  echo
  echo install raspi-config package
  apt-get -y install raspi-config
  which raspi-config
fi

echo
echo "raspberry hardware version"
raspi-config nonint get_pi_type

echo 
read -p "change hostname [photoframe] " hostname
if test -z "$hostname"; then
  hostname=photoframe
fi
raspi-config nonint do_hostname $hostname

echo
echo 'Enable Boot to Desktop and autologin as "pi"'
raspi-config nonint do_boot_behaviour "B4"

echo
if raspi-config nonint is_pione; then
  echo 'Modest overclock 800 250 400 0'
  raspi-config nonint do_overclock "Modest"
fi

echo
echo Set GPU memory to 64
raspi-config nonint do_memory_split 64

echo
echo expand fs
raspi-config nonint do_expand_rootfs

echo finished.
raspi-config nonint do_finish
