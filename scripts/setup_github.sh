#!/bin/bash

set -e
command -v git

if test $EUID -eq 0; then
  echo "$0 must be run as normal user."
  exit 1
fi

DESTINATION=$HOME/app
DESTINATION_PHOTOFRAME=$DESTINATION/photoframe

mkdir -p $DESTINATION

if ! [ -e $DESTINATION_PHOTOFRAME ]; then
	git clone https://github.com/ukos-git/photoframe $DESTINATION_PHOTOFRAME
else
	pushd $DESTINATION_PHOTOFRAME
	git pull -q
  popd
fi
