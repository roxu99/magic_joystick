#!/bin/bash

#
# Ce script permet la désactivation du point d'accès wifi sur la Raspi
# Il doit être lancer après le script de setup "AP_setup.sh"
# On ne fait que copier les fichier <file.bak> dans les fichiers système
# TODO [Important: redémarrer en coupant le jus de la raspi (???)]
#

if [ "$EUID" -ne 0 ]
  then echo "Must run as root: 'sudo ./AP_stop.sh'"
  exit
fi

# Check si setup fait ou pas
if [ -e /etc/dhcpcd.conf.bak ] then 
  echo "Désactivation du point d'accès..."
else 
  echo "Il faut d'abord lancer le setup: 
  sudo ./AP_setup.sh"
  exit 1
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

echo "Redémarrez maintenant :
sudo poweroff"