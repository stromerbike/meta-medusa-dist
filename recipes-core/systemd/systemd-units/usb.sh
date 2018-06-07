#!/bin/dash

NAME=usb
DESC="Initialization of USB to OTG SDP mode"

case $1 in
start)
    # FORCE_OTG1_ID
    echo "23" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio23/direction
    echo "1" > /sys/class/gpio/gpio23/value

    # ILIM_SEL = ILIM_HI (1.5A)
    echo "504" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio504/direction
    echo "1" > /sys/class/gpio/gpio504/value

    # CTL2
    echo "506" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio506/direction
    echo "1" > /sys/class/gpio/gpio506/value
;;

stop)
    echo "0" > /sys/class/gpio/gpio506/value
    echo "0" > /sys/class/gpio/gpio23/value
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
