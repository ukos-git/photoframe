#!/bin/sh
apt-get install raspi-config
# use raspi-config bash script
source raspi-config nonint
echo "raspberry hardware version"
get_pi_type
# change hostname
do_hostname "pichannel"
# Enable Boot to Desktop and autologin as "pi"
do_boot_behaviour "B4"
# Modest overclock 800 250 400 0
if is_pione; then
	do_overclock "Modest"
else
	do_overclock "None"
fi
# Set GPU memory to 64
do_memory_split 64
# expand fs
do_expand_rootfs
# reboot
do_finish
