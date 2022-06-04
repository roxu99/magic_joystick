#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as root"
  exit
fi

./bin/Bluetooth/prepare_bluetooth.sh

# Create log directory
mkdir -p /var/log/magick_joy/log
export MAGICK_JOY_LOG=`mktemp -d -p /dev/shm/log/magick_joy/log`
chown -R 1000:1000 $MAGICK_JOY_LOG

supervisord -c supervisord.conf
