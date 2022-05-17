#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Must run as root: 'sudo ./AP_start.sh'"
  exit
fi

# Enable the wireless access point service and set it to start when your Raspberry Pi boots
systemctl unmask hostapd
systemctl enable hostapd

cp /etc/dhcpcd.conf.ap /etc/dhcpcd.conf

cp /etc/dnsmasq.conf.ap /etc/dnsmasq.conf

#enable wifi connexion
rfkill unblock wlan

cp /etc/hostapd/hostapd.conf.ap /etc/hostapd/hostapd.conf

cp /etc/default/hostapd.ap /etc/default/hostapd


service hostapd start

echo "Please reboot now with : 
systemctl reboot"