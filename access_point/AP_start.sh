#!/bin/bash

# Enable the wireless access point service and set it to start when your Raspberry Pi boots
sudo systemctl unmask hostapd
sudo systemctl enable hostapd

sudo cp /etc/dhcpcd.conf.ap /etc/dhcpcd.conf

sudo cp /etc/dnsmasq.conf.ap /etc/dnsmasq.conf

#enable wifi connexion
sudo rfkill unblock wlan

sudo cp /etc/hostapd/hostapd.conf.ap /etc/hostapd/hostapd.conf

sudo cp /etc/default/hostapd.ap /etc/default/hostapd


sudo service hostapd start

echo "Please reboot now with : 
sudo systemctl reboot"