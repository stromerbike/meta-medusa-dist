#!/bin/dash

NAME=gpio
DESC="Initialization of internal and external (if present) gpio expander"

case $1 in
start)
    # configure multipurpose-interface for i2c usage
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

    # turn on the 5V_OUT supply voltage
    i2cset -y 2 0x20 0x06 0xfb
    i2cset -y 2 0x20 0x02 0xff

    # load gpio expander driver
    modprobe gpio_pca953x
;;

stop)
    # unload gpio expander driver
    modprobe -r gpio_pca953x

    # turn off the 5V_OUT supply voltage
    i2cset -y 2 0x20 0x02 0xfb
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
