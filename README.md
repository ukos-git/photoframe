# Photo frame for the raspberry pi

A setup for a photo display frame with a raspberry pi. The modifications are
based on a standard *raspibian*. It adds automatic E-Mail retrieval and filters
out the pictures from the attachment. It then displays these images as a
slideshow.

## hardware

You will need a rapberry pi prepared with a bookworm release. The installation
routine is tested with `2024-03-15-raspios-bookworm-arm64.img.xz`

## setup

The scripts are divided into three groups:

- anything that affects the system
- installation and configuration of third party software
- optional changes

The first two groups of scripts are mandatory for the functionality of the pi.
The third group is up to the user to execute.

### download

```
cd $HOME/Downloads
wget https://raw.githubusercontent.com/ukos-git/photoframe/master/scripts/setup_github.sh
bash setup_github.sh
```

This will download and execute `scripts/setup_github.sh`. The script clones the
necessary dependencies into `~/app` directory of the current user. This
repository is cloned into `~/app/photoframe`.

### system

Changes to the system need to be executed with root privilegeds. If in doubt,
check the content of the files before executing them.

- `scripts/init_raspbian.sh` does a a full system upgrade and update the firmware.
- `scripts/init_pi.sh` sets up some global configuration of the system like autologin.
- `scripts/setup_bootlogo.sh` set the plymouth boot logo to `img/logo.png`

These scripts should only be executed once at the initial system configuration

### features

configuration of additional features:

- `scripts/setup_getmail.sh` install comand line mail client as cron job
- `scripts/setup_slideshow.sh` install autoload of `media` folder slideshow
- `scripts/config_desktop.sh` remove panel, set background, remove screen blanking

### manual configuration

- add mail credentials to `~/.getmail/getmailrc`
- connect to the appropriate wifi preferrably in the lxde desktop environment.

## fork

This project is based on [Grandpa's familiy
Channel](http://www.reddipped.com/2014/06/grandpas-family-channel/) and
integrates code from

- [reddipped](https://github.com/reddipped) with [reddipped/PIChannel](https://github.com/reddipped/PIChannel)
- [davearias](https://github.com/davearias) with [davearias/PIChannel_dea](https://github.com/davearias/PIChannel_dea)
- [strompi](https://github.com/joy-it/strompi3)
