#!/bin/dash

NAME=gsm
DESC="Initialization of gsm chip"

case $1 in
start)
    # GSM power on
    # GPIO5 IO05 => (5 - 1) * 32 + 5 = 133
    echo "133" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio133/direction
    echo "0" > /sys/class/gpio/gpio133/value
    # GSM reset
    # GPIO5 IO00 => (5 - 1) * 32 = 128
    echo "128" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio128/direction
    echo "0" > /sys/class/gpio/gpio128/value
    # 3v7_ON enable voltage (GPIO expander)
    echo "497" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio497/direction
    echo "1" > /sys/class/gpio/gpio497/value
    # Wait for voltage to rise
    sleep 0.2
    # Make pulse to start GSM module
    echo "1" > /sys/class/gpio/gpio133/value
    sleep 0.1
    echo "0" > /sys/class/gpio/gpio133/value
    sleep 0.5
    modprobe imx6ul_mod_uart
;;

stop)
    # Remove uart driver
    rmmod imx6ul_mod_uart
    # Disable 3v7 voltage
    echo "0" > /sys/class/gpio/gpio497/value
;;

reload)
    # Pulse GSM reset
    echo "1" > /sys/class/gpio/gpio128/value
    sleep 0.1
    echo "0" > /sys/class/gpio/gpio128/value
;;

*)
    echo "Usage $0 {start|stop|reload}"
    exit
esac
