#/bin/sh
sudo apt-get -q -y install \
	getmail4 \
	imagemagick \
	maildir-utils
mkdir -p ~/.getmail
rsync /home/pi/github/pichannel/scripts/processmail/getmailrc ~/.getmail/
mkdir -p ~/mail.mbox/new
mkdir -p ~/mail.mbox/cur
mkdir -p ~/mail.mbox/tmp
# schedule mail retrieval and processing
(crontab -l; \
echo "*/5 * * * * /bin/sh /home/pi/github/pichannel/scripts/processmail/processmail.sh" ) \
| crontab -
# create empty status file
touch /var/tmp/processmail.sts
# rebuild presentation on boot
sudo sed --in-place '/^exit 0/i sudo -u pi /bin/sh /home/pi/github/pichannel/scripts/processmail/rebuild_media.sh &' /etc/rc.local
# create processmail.sts on boot
sudo sed --in-place '/^exit 0/i sudo -u pi touch /var/tmp/processmail.sts &' /etc/rc.local
