#!/bin/dash

NAME=gpio
DESC="Configures the multipurpose-interface for i2c usage"

case $1 in
start)
    # I2C4_PU
    echo 51 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio51/direction
    echo 1 > /sys/class/gpio/gpio51/value

    # I2C4_ON
    echo 114 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio114/direction
    echo 1 > /sys/class/gpio/gpio114/value
;;

stop)
    # Disable I2C4 level shifter
    echo 0 > /sys/class/gpio/gpio114/value

    # Disconnect pullup on I2C4
    echo 0 > /sys/class/gpio/gpio51/value
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
