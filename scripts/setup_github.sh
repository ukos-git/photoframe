#!/bin/bash
# install/update github repositories
#
sudo apt-get -y -q install \
	git
sudo -u pi mkdir -p /home/pi/github
# install pichannel
if [ ! -e /home/pi/github/pichannel ]; then
	sudo -u pi git clone https://github.com/ukos-git/PIChannel_ukos /home/pi/github/pichannel
	# sudo -u pi git clone https://github.com/reddipped/PIChannel /home/pi/github/pichannel
else
	cd /home/pi/github/pichannel
	sudo -u pi git pull -q
fi
# install pipresents
if [ ! -e /home/pi/github/pipresents-next ]; then
	sudo -u pi git clone https://github.com/KenT2/pipresents-next.git /home/pi/github/pipresents-next
else
	cd /home/pi/github/pipresents-next
	sudo -u pi git pull -q
fi
# install pipresents-examples
if [ ! -e /home/pi/github/pipresents-next-examples ]; then
	sudo -u pi git clone https://github.com/KenT2/pipresents-next-examples.git /home/pi/github/pipresents-next-examples
else
	cd /home/pi/github/pipresents-next-examples
	sudo -u pi git pull -q
fi
