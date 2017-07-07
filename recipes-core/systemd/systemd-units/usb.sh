#! /bin/bash

NAME=power
DESC="Initialization of USB to SDP mode"

case $1 in
start)
    # CTL2
    echo "506" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio506/direction
    echo "1" > /sys/class/gpio/gpio506/value
;;

stop)
    echo "0" > /sys/class/gpio/gpio506/value
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
