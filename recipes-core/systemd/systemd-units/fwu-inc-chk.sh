#! /bin/bash

NAME=fwu-inc-chk
DESC="Checks if requirements are met for incremental firmware update and displays a warning if not"

case $1 in
start)
    if cat /proc/mounts | head -n1 | grep "\sro[\s,]"; then
        echo "Active partition is mounted as readonly"
        exit 0
    else
        echo "Active partition is mounted as readwrite"
        echo "255" > /sys/class/leds/rgb1_green/brightness || true
        echo "255" > /sys/class/leds/rgb1_red/brightness || true
        echo "255" > /sys/class/leds/rgb2_green/brightness || true
        echo "255" > /sys/class/leds/rgb2_red/brightness || true
        exit 1
    fi
;;

*)
    echo "Usage $0 start"
    exit
esac
