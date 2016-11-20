#!/bin/sh
## Disable screenblanking and screensaver
sudo sed --in-place '/#!\/bin\/sh/a\# Disable screenblanking\n\xset s off\n\xset -dpms\n\xset s noblank' /etc/X11/xinit/xinitrc
sudo sed --in-place 's/^#xserver-command=X/xserver-command=X -s 0 -dpms/' /etc/lightdm/lightdm.conf
