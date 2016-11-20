#!/bin/sh+
# install requirements
apt-get -y install \
	fbi \
	raspi-config
# use raspi-config bash script
source raspi-config nonint
# copy splash screen script to init system
cp -f /home/pi/github/pichannel/scripts/aasplashscreen /etc/init.d/asplashscreen
chmod u+x /etc/init.d/asplashscreen
update-rc.d asplashscreen defaults
# copy splash screen image to file system
mkdir -p /opt/pichannel
cp -f /home/pi/github/pichannel/img/pichannel.png /opt/pichannel
# boot mode quiet on tty3
do_boot_splash 0
sed --in-place "s/\<console=tty[[:digit:]]\>/console=tty3/" /boot/cmdline.txt
sed --in-place "s/\<splash\>//" /boot/cmdline.txt
# reboot to test
ASK_TO_REBOOT=1
do_finish