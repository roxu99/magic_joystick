#!/bin/bash
sudo systemctl mask hostapd

#cp /etc/dhcpcd.conf /etc/dhcpcd.conf.ap
sudo cp /etc/dhcpcd.bak /etc/dhcpcd.conf

sudo cp /etc/dnsmasq.conf.bak /etc/dnsmasq.conf

sudo cp /etc/hostapd/hostapd.conf.bak /etc/hostapd/hostapd.conf

sudo cp /etc/default/hostapd.bak /etc/default/hostapd

sudo service hostapd stop

echo "Please reboot now with : 
sudo systemctl reboot"