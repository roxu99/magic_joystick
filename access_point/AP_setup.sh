#!/bin/bash

# Ce script permet l'initialisation des fichiers servants à l'activation et à la désactivation de l'acces point sur la Raspi
# Les variables SSID WIFIPSWD CHANNEL IPRESO sont à changer. 
# Par défaut l'adresse IP de la raspi est "IPRESO.1"
# 
# 1 - Création de fichiers <file>.bak qui servent à sauvegarder l'état initiale de ces fichiers 
# 2 - Création de fichier <file>.ap avec le contenu necessaire au fonctionnement de l'Acces Point
# 
# Notes : 
#   - Il est important de ne PAS indenter le fichier (les echo le seraient aussi dans les fichiers destination)
#   - Par défaut le point d'accès est désactivé. Utilisez "sudo ./AP_start.sh" pour l'activer.
#

SSID="raspi-ap"
WIFIPSWD="raspi123456" #Min 8 lettres et chiffes
CHANNEL="11" # A changer si pluieurs raspi proches
IPRESO="192.168.4" #192.168.X ou 10.X.X


if [ "$EUID" -ne 0 ]
  then echo "Must run as root: 'sudo ./AP_setup.sh'"
  exit 1
fi

echo ""
echo "Mise en place des fichiers de configuration (et backups) pour l'Access Point"


# Set up the Network Router
if [ -e /etc/dhcpcd.conf.bak ]
then 
echo "Le fichier /etc/dhcpcd.conf.bak existe déjà."
else 
cp /etc/dhcpcd.conf /etc/dhcpcd.conf.bak
cp /etc/dhcpcd.conf /etc/dhcpcd.conf.ap
echo "
# RaspAP wlan0 configuration
interface wlan0
static ip_address=$IPRESO.1/24
static router=$IPRESO.1
static domain_name_servers=$IPRESO.1 8.8.8.8" >> /etc/dhcpcd.conf.ap
echo "Le fichier /etc/dhcpcd.conf est correctement configuré "
fi

if [ -e /etc/dnsmasq.conf.bak ]
then 
echo "Le fichier /etc/dnsmasq.conf.bak existe déjà."
else 
cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
echo "# Listening interface
interface=wlan0

# Pool of IP addresses served via DHCP
dhcp-range=$IPRESO.2,$IPRESO.20,255.255.255.0,24h

# Local wireless DNS domain
domain=wlan

# Alias for this router
address=/gw.wlan/$IPRESO.1" > /etc/dnsmasq.conf.ap
echo "Le fichier /etc/dnsmasq.conf est correctement configuré "
fi

#enable wifi connexion
#rfkill unblock wlan

if [ -e /etc/hostapd/hostapd.conf.bak ]
then 
echo "Le fichier /etc/hostapd/hostapd.conf.bak existe déjà."
else 
touch /etc/hostapd/hostapd.conf
cp /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.bak
echo "
#with all Linux driver mac80211
driver=nl80211
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
beacon_int=100

# Wi-Fi secured, authentification needed (if not, auth_algs=0)
auth_algs=1

# parameters for wifi WPA2
wpa_key_mgmt=WPA-PSK
wpa=2
wpa_pairwise=CCMP
wpa_pairwise=TKIP

# wifi pswd
wpa_passphrase=$WIFIPSWD

# Name of spot wifi
ssid=$SSID

# Frequency channel
channel=$CHANNEL

# mode Wi-Fi (a = IEEE 802.11a, b = IEEE 802.11b, g = IEEE 802.11g)
hw_mode=g

# wlan interface of wifi
interface=wlan0

country_code=FR
## Rapberry Pi 3 specific to on board WLAN/WiFi
#ieee80211n=1 # 802.11n support (Raspberry Pi 3)
#wmm_enabled=1 # QoS support (Raspberry Pi 3)
#ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40] # (Raspberry Pi 3)

## RaspAP wireless client AP mode
#interface=uap0

## RaspAP bridge AP mode (disabled by default)
#bridge=br0


# Station MAC address -based authentication (driver=hostap or driver=nl80211)
# 0 = accept unless in deny list
# 1 = deny unless in accept list
# 2 = use external RADIUS server (accept/deny lists are searched first)
macaddr_acl=0

# Accept/deny lists are read from separate files
#accept_mac_file=/etc/hostapd/hostapd.accept
#deny_mac_file=/etc/hostapd/hostapd.deny

# Rend le nom du point d'acces wifi invisible (0 desactive, 1 active)
ignore_broadcast_ssid=0" > /etc/hostapd/hostapd.conf.ap
echo "Le fichier /etc/hostapd/hostapd.conf est correctement configuré "
fi

if [ -e /etc/default/hostapd.bak ]
then 
echo "Le fichier /etc/default/hostapd.bak exist déjà."
else 
cp /etc/default/hostapd /etc/default/hostapd.bak
echo "DAEMON_CONF=\"etc/hostapd/hostapd.conf\"" > /etc/default/hostapd.ap
echo "Le fichier /etc/default/hostapd est correctement configuré "
fi

echo ""

# Commandes pour supprimer tous les fichier bak ou ap
# sudo rm -f /etc/dhcpcd.conf.ap
# sudo rm -f /etc/dnsmasq.conf.ap
# sudo rm -f /etc/hostapd/hostapd.conf.ap
# sudo rm -f /etc/default/hostapd.ap
# sudo rm -f /etc/dhcpcd.conf.bak
# sudo rm -f /etc/dnsmasq.conf.bak
# sudo rm -f /etc/hostapd/hostapd.conf.bak
# sudo rm -f /etc/default/hostapd.bak
# sudo rm -f /etc/hostapd/hostapd.conf