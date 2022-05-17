#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Must run as root: 'sudo ./AP_stop.sh'"
  exit
fi

systemctl mask hostapd

#cp /etc/dhcpcd.conf /etc/dhcpcd.conf.ap
cp /etc/dhcpcd.conf.bak /etc/dhcpcd.conf

cp /etc/dnsmasq.conf.bak /etc/dnsmasq.conf

cp /etc/hostapd/hostapd.conf.bak /etc/hostapd/hostapd.conf

cp /etc/default/hostapd.bak /etc/default/hostapd

service hostapd stop

#enable wifi connexion
rfkill unblock wlan

echo "Please shutdown now with : 
sudo poweroff"