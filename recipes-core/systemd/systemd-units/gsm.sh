#!/bin/bash

NAME=gsm
DESC="Initialization of gsm chip"

wait_ttyACM0 ()
{
    echo "Waiting for ttyACM0..."
    while [ ! -e /dev/ttyACM0 ]; do
        sleep 1
    done
    # Wait for some seconds or dial command ATDT*99# will not succeed
    sleep 1
    echo "...done"
}

workaround_ttyACM0 ()
{
    if ls -l `which timeout` | grep busybox > /dev/null; then
        echo "Timeout provided by busybox"
        timeout -t 3 microcom /dev/ttyACM0 &>/dev/null || true
    else
        echo "Timeout provided by coreutils"
        timeout 3 microcom /dev/ttyACM0 &>/dev/null || true
    fi
}

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
    # Wait for 3v7 to reach a stable value
    sleep 0.1
    # Start GSM module
    echo "1" > /sys/class/gpio/gpio133/value
    # Wait until ttyACM0 is present
    wait_ttyACM0
    # WORKAROUND: Read out any garbage from ttyACM0
    workaround_ttyACM0
;;

stop)
    # Disable 3v7 voltage
    echo "0" > /sys/class/gpio/gpio497/value
;;

reload)
    # Pulse GSM reset
    echo "1" > /sys/class/gpio/gpio128/value
    sleep 0.1
    echo "0" > /sys/class/gpio/gpio128/value
    # Wait until ttyACM0 is present
    wait_ttyACM0
    # WORKAROUND: Read out any garbage from ttyACM0
    workaround_ttyACM0
;;

*)
    echo "Usage $0 {start|stop|reload}"
    exit
esac
