#!/bin/bash

#
# Ce script permet l'activation du point d'accès wifi sur la Raspi
# Il doit être lancer après le script de setup "AP_setup.sh"
# On ne fait que copier les fichier <file.ap> dans les fichiers système
# TODO [Important: redémarrer en coupant le jus de la raspi (???)]
#

if [ "$EUID" -ne 0 ]
  then echo "Must run as root: 'sudo ./AP_start.sh'"
  exit
fi

# Check si setup fait ou pas
if [ -e /etc/dhcpcd.conf.bak ] then 
  echo "Activation du point d'accès..."
else 
  echo "Il faut d'abord lancer le setup: 
  sudo ./AP_setup.sh"
  exit 1
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

echo "Redémarrez maintenant : 
sudo poweroff"