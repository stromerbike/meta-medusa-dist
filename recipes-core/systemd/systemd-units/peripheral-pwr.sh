#!/bin/dash

NAME=gpio
DESC="Controls the 5V_OUT supply voltage"

case $1 in
start)
    # turn on the 5V_OUT supply voltage
    echo 498 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio498/direction
    echo 1 > /sys/class/gpio/gpio498/value
;;

stop)
    # turn off the 5V_OUT supply voltage
    echo 0 > /sys/class/gpio/gpio498/value
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
