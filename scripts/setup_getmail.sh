#/bin/sh

set -e

if test $EUID -eq 0; then
  echo "$0 must be run as normal user."
  exit 1
fi

mkdir -p /home/pi/.getmail
mkdir -p /home/pi/mail.mbox/new
mkdir -p /home/pi/mail.mbox/cur
mkdir -p /home/pi/mail.mbox/tmp

# schedule mail retrieval and processing
(crontab -l; echo "*/5 * * * * /bin/sh /home/pi/app/photoframe/scripts/processmail.sh" ) | crontab -
