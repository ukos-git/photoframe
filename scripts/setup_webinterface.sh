#!/bin/sh
sudo apt-get -y install lighttpd
sudo sed --in-place "s/^\(server.document-root.*=\).*/\1 \"\/home\/pi\/www\/http\"/" /etc/lighttpd/lighttpd.conf
sudo sed --in-place "s/^\(server.modules = (\)/\1\n\t\"mod_cgi\",/" /etc/lighttpd/lighttpd.conf
sudo sed --in-place "s/^\(index-file.names.*=.*(.*\)).*/\1, \"index.py\")/" /etc/lighttpd/lighttpd.conf
sudo sed --in-place "s/^\(server\.username.*=\).*/\1 \"pi\"/" /etc/lighttpd/lighttpd.conf
sudo sed --in-place "s/^\(server\.groupname.*=\).*/\1 \"pi\"/" /etc/lighttpd/lighttpd.conf

cat << EOF | sudo tee -a /etc/lighttpd/lighttpd.conf
\$HTTP["url"] =~ "^/" {
    cgi.assign = (".py" => "/usr/bin/python")
}
EOF

mkdir -p /home/pi/www/
rsync -a /home/pi/github/pichannel/scripts/www/ /home/pi/www/
chmod u+x /home/pi/www/http/*.py
chmod u+x /home/pi/www/py/*.py
sudo chown -R pi:pi /var/log/lighttpd
sudo service lighttpd restart

# At disabled scheduled shutdown for root
/usr/bin/sudo /usr/bin/crontab -l | /bin/sed '1 a #50 23 * * * \/sbin\/shutdown -hF 0' | /usr/bin/sudo /usr/bin/crontab -
