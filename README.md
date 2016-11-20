PIChannel
=============

This Version of PIChannel brings some improvements on the setup scripts.

It also includes some impovements from davearias and was then rebased to upstream by reddiped.

List of Improvements
=============
* Installation scripts make use of the [raspi-config](https://github.com/RPi-Distro/raspi-config) script
* reduced the use of wget and used a clone from github instead
* Shuffle playback mode
* upload media via web interface
* scan for media that was not emailed

Installation order
=============
The scripts are divided in three groups:

* anything that affects the system
* installation and configuration of third party software
* optional changes

The first two groups of scripts are mandatory for the functionality of the pi.
The third group is up to the user to execute.

recommended execution order of the scripts is

changes to the system
* update_raspbian_and_firmware.sh
* init_pi.sh
* setup_github.sh
* setup_bootlogo.sh
* setup_wifi.sh

configuration of additional features
* setup_webinterface.sh
* setup_getmail.sh
* setup_pipresents.sh
* config_screensaver.sh

wifi and mail provider can be set via the web-gui. If you want to set it manually look below

if everything works you could do some clean up
* config_desktop.sh
* config_raspbian.sh

manual setup
=============
manually change wifi configuration as setup_wifi is a little bit hacky.
```
sudo vim /etc/network/interfaces
```
manually edit getmailrc
```
vim ~/.getmail/getmailrc
```

manual checks
=============
check the crontab for duplicate tasks
```
crontab -l
sudo crontab -l
```
correct them via
```
crontab -e
```
also check rc.local for duplicates
```
sudo vim /etc/rc.local
```
Project contributers
=============
The project uses a lot of third party packages but the fork is derived from
* [reddipped](https://github.com/reddipped) with [reddipped/PIChannel](https://github.com/reddipped/PIChannel)
* [davearias](https://github.com/davearias) with [davearias/PIChannel_dea](https://github.com/davearias/PIChannel_dea)

Original contributer's Blog entry
=============
[Grandpa's familiy Channel](http://www.reddipped.com/2014/06/grandpas-family-channel/)
