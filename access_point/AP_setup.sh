#!/bin/bash

sudo apt install hostapd
sudo apt install dnsmasq

SSID="raspi-ap"
WIFIPSWD="raspi123456"
CHANNEL="11"

# Set up the Network Router
if [ -e /etc/dhcpcd.conf.bak ]
then 
echo "Le fichier /etc/dhcpcd.conf.bak existe
-> Arret de AP_setup.sh"
exit 0
else 
sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.bak
sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.ap
echo "
# RaspAP wlan0 configuration
interface wlan0
static ip_address=192.168.4.1/24
static router=192.168.4.1
static domain_name_servers=192.168.4.1 8.8.8.8" >> /etc/dhcpcd.conf.ap

fi

if [ -e /etc/dnsmasq.conf.bak ]
then 
echo "Le fichier /etc/dnsmasq.conf.bak exist
Arret de AP_setup.sh"
exit 0
else 
sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
echo "# Listening interface
interface=wlan0

# Pool of IP addresses served via DHCP
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h

# Local wireless DNS domain
domain=wlan

# Alias for this router
address=/gw.wlan/192.168.4.1" > /etc/dnsmasq.conf.ap
fi

#enable wifi connexion
#sudo rfkill unblock wlan

if [ -e /etc/hostapd/hostapd.conf.bak ]
then 
echo "Le fichier /etc/hostapd/hostapd.conf.bak exist
Arret de AP_setup.sh"
exit 0
else 
sudo cp /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.bak
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
fi

if [ -e /etc/default/hostapd.bak ]
then 
echo "Le fichier /etc/default/hostapd.bak exist
Arret de AP_setup.sh"
exit 0
else 
sudo cp /etc/default/hostapd /etc/default/hostapd.bak
echo "DAEMON_CONF=\"etc/hostapd/hostapd.conf\"" > /etc/default/hostapd.conf.ap
fi
