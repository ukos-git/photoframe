#!/bin/sh
sudo apt-get -y install \
	mplayer \
	python-imaging \
	python-imaging-tk \
	python-pexpect \
	unclutter \
	uzbl \
	x11-xserver-utils
# load from github repositories
sh /home/pi/github/pichannel/scripts/setup_github.sh
# pipresents config
rsync -a /home/pi/github/pipresents-next-examples/pp_home ~/
touch /home/pi/pp_home/media-metadata
mkdir -p /home/pi/pp_home/media
mkdir -p /home/pi/pp_home/pp_profiles
rsync -a /home/pi/github/pichannel/livephoto /home/pi/pp_home/pp_profiles/
# prepare auto start
mkdir -p /home/pi/.config/autostart
rsync /home/pi/github/pichannel/scripts/pipresents.desktop /home/pi/.config/autostart/
