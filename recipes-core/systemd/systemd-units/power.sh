#! /bin/bash

NAME=power
DESC="Initialization of 5V power supply"

case $1 in
start)
    # Power Supply Control (5V_OUT_ON)
    echo "498" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio498/direction
    echo "1" > /sys/class/gpio/gpio498/value
;;

stop)
    echo "0" > /sys/class/gpio/gpio498/value
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
