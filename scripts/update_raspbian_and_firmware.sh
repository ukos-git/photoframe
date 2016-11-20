#!/bin/sh
# remove to save upgrade
apt-get -y remove wolfram-engine
# update to latest raspbian
apt-get -y update && apt-get -y dist-upgrade \
&& apt-get -y autoremove && apt-get -y autoclean \
apt-get -y upgrade
# Update firmware
apt-get -y install rpi-update
rpi-update
shutdown -r 0 now
