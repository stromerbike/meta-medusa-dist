#! /bin/bash

NAME=gsm
DESC="Initialization of gsm chip"

case $1 in
start)
    # GSM power on
    # GPIO1 IO02 => (1 -1) * 32 + 2 = 2
    echo "2" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio2/direction
    echo "0" > /sys/class/gpio/gpio2/value
    # GSM reset
    # GPIO5 IO00 => (5 - 1) * 32 = 128
    echo "128" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio128/direction
    echo "0" > /sys/class/gpio/gpio128/value
    # 3v7_ON enable voltage (GPIO expander)
    echo "497" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio497/direction
    echo "1" > /sys/class/gpio/gpio497/value
    # Make pulse to start GSM module
    echo "1" > /sys/class/gpio/gpio2/value
    sleep 0.03
    echo "0" > /sys/class/gpio/gpio2/value
;;

stop)
    # Disable 3v7 voltage
    echo "0" > /sys/class/gpio/gpio497/value
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
