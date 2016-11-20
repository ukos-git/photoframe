#!/bin/sh
# remove unnecessary packages
apt-get -y remove wolfram-engine
# update to latest raspbian
apt-get -y update
apt-get -y dist-upgrade
apt-get -y upgrade
apt-get -y autoremove
apt-get -y autoclean
# update firmware
apt-get -y install rpi-update
rpi-update
# restart pi
shutdown -r 0 now
