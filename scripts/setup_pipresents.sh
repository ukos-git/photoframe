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
touch /home/pi/pp_home/media-metadata
mkdir -p /home/pi/pp_home/media
# copy pp examples from repo
ln -s -f /home/pi/github/pipresents-next-examples/pp_home/media/* /home/pi/pp_home/media/
mkdir -p /home/pi/pp_home/pp_profiles
ln -s -f /home/pi/github/pipresents-next-examples/pp_home/pp_profiles/* /home/pi/pp_home/pp_profiles/
# create our profile (link to repo)
mkdir -p /home/pi/pp_home/pp_profiles/livephoto
ln -s -f /home/pi/github/pichannel/livephoto/* /home/pi/pp_home/pp_profiles/livephoto/
rm /home/pi/pp_home/pp_profiles/livephoto/gpio.cfg
rm /home/pi/pp_home/pp_profiles/livephoto/media.json
rsync -a /home/pi/github/pichannel/livephoto/gpio.cfg /home/pi/pp_home/pp_profiles/livephoto/
rsync -a /home/pi/github/pichannel/livephoto/media.json /home/pi/pp_home/pp_profiles/livephoto/
# prepare auto start
mkdir -p /home/pi/.config/autostart
rsync /home/pi/github/pichannel/scripts/pipresents.desktop /home/pi/.config/autostart/
# weekly update rpi on sunday at 2am
(sudo crontab -l; echo "00 02 * * 0 /bin/bash /home/pi/github/pichannel/scripts/update.sh" ) \
| sudo crontab -
