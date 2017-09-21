#!/bin/bash

NAME=pwr-io
DESC="Initialization of 5V power supply for I/O operations"

case $1 in
start)
    # 5V_OUT_ON (powers 5V_OUT which is used for buttons, TMM, etc.)
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
