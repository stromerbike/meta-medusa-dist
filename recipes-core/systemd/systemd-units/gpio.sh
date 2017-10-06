#!/bin/dash

NAME=gpio
DESC="Initialization of internal and external (if present) gpio expander"

case $1 in
start)
    echo 18 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio18/direction

    echo 19 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio19/direction

    echo 51 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio51/direction
    echo 1 > /sys/class/gpio/gpio51/value

    echo 114 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio114/direction
    echo 1 > /sys/class/gpio/gpio114/value

    i2cset -y 2 0x20 0x06 0xfa
    i2cset -y 2 0x20 0x02 0xff

    modprobe gpio_pca953x
;;

stop)
    modprobe -r gpio_pca953x
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
