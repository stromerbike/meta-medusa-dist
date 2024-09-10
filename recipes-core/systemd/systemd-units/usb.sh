#!/bin/dash

NAME=usb
DESC="Initialization of USB to OTG SDP mode"

case $1 in
start)
    # FORCE_OTG1_ID
    test -e /sys/class/gpio/gpio23 || echo "23" > /sys/class/gpio/export
    echo "high" > /sys/class/gpio/gpio23/direction

    # ILIM_SEL = ILIM_LO (1A)
    test -e /sys/class/gpio/gpio520 || echo "520" > /sys/class/gpio/export
    echo "low" > /sys/class/gpio/gpio520/direction

    # CTL2
    test -e /sys/class/gpio/gpio522 || echo "522" > /sys/class/gpio/export
    echo "high" > /sys/class/gpio/gpio522/direction
;;

stop)
    echo "0" > /sys/class/gpio/gpio522/value
    echo "0" > /sys/class/gpio/gpio23/value
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
