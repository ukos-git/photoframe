#!/bin/sh+
# install requirements
apt-get -y install \
	fbi \
	raspi-config
# use raspi-config bash script
source raspi-config nonint
update-rc.d aasplashscreen defaults
cp /var/tmp/pichannel.png /etc
# boot mode quiet on tty3
do_boot_splash 0
sed --in-place "s/\<console=tty[[:digit:]]\>/console=tty3/" /boot/cmdline.txt
sed --in-place "s/\<splash\>//" /boot/cmdline.txt
# reboot to test
ASK_TO_REBOOT=1
do_finish