#!/bin/dash

sed "s/^ssid=.*/ssid=$(hostname)/" </etc/hostapd.conf >/tmp/hostapd.conf
