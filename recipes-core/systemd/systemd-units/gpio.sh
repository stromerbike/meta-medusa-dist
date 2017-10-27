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

    # turn on the supply voltages 5V & 5V_Out
    i2cset -y 2 0x20 0x06 0xfa
    i2cset -y 2 0x20 0x02 0xff

    # load gpio expander driver
    modprobe gpio_pca953x
    
    # compatibility for V2 & V4, delete for release-stage
    echo 498 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio498/direction
    echo 1 > /sys/class/gpio/gpio498/value
;;

stop)
    # unload gpio expander driver
    modprobe -r gpio_pca953x

    # turn off the supply voltages 5V & 5V_Out
    i2cset -y 2 0x20 0x02 0xfa
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
