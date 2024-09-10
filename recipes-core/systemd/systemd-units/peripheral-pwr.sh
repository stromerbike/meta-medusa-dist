#!/bin/dash

NAME=peripheral-pwr
DESC="Controls the 5V_OUT supply voltage"

case $1 in
start)
    # prepare I2C4 pullup
    echo 1 > /sys/class/gpio/gpio51/value

    # enable I2C4
    echo 1 > /sys/class/gpio/gpio114/value

    # turn on the 5V_OUT supply voltage
    test -e /sys/class/gpio/gpio514 || echo 514 > /sys/class/gpio/export
    echo "high" > /sys/class/gpio/gpio514/direction
;;

stop)
    # turn off the 5V_OUT supply voltage
    echo 0 > /sys/class/gpio/gpio514/value

    # disable I2C4
    echo 0 > /sys/class/gpio/gpio114/value

    # disconnect I2C4 pullup
    echo 0 > /sys/class/gpio/gpio51/value
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
