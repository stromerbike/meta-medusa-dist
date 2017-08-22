#! /bin/bash

NAME=pwr-sup
DESC="Initialization of 5V power supply for power delivery"

case $1 in
start)
    # 5V_ON (powers 5V and 5V_OUT_IC which are used for USB, LED's and MPIO_1/MPIO_2)
    echo "496" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio496/direction
    echo "1" > /sys/class/gpio/gpio496/value
;;

stop)
    echo "0" > /sys/class/gpio/gpio496/value
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
