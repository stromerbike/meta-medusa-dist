#! /bin/bash

NAME=led
DESC="Initialization of led chip"

case $1 in
start)
    # Enable led chip
    echo "500" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio500/direction
    echo "1" > /sys/class/gpio/gpio500/value
    # Load driver
    modprobe leds_lp5523
;;

stop)
    rmmod leds_lp5523
    rmmod leds_lp55xx_common
    echo "0" > /sys/class/gpio/gpio500/value
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
