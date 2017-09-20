#!/bin/sh

## set unique SSID
if [ -e /sys/class/net/wlan0/address ]; then
    address=$(< /sys/class/net/wlan0/address)
    MAC=$(sed 's/://g' /sys/class/net/wlan0/address)
    NEW_SSID="WIFI-MEDUSA-${MAC}"
    eval sed 's/^ssid=.*/ssid=${NEW_SSID}/' </etc/hostapd.conf >/mnt/data/hostapd.conf
fi

