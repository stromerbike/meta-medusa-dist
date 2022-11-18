#!/bin/dash

NAME=gsm
DESC="Initialization of gps chip"

case $1 in
start)
    # GNSS_RESET (to gate of V15 on /RESET = ~GNSS_RESET)
    # GPIO4 IO28 => (4 - 1) * 32 + 28 = 124
    test -e /sys/class/gpio/gpio124 || echo "124" > /sys/class/gpio/export
    echo "low" > /sys/class/gpio/gpio124/direction
    # GNSS_FORCE_ON (on FORCE_ON)
    # GPIO4 IO26 => (4 - 1) * 32 + 26 = 122
    test -e /sys/class/gpio/gpio122 || echo "122" > /sys/class/gpio/export
    echo "low" > /sys/class/gpio/gpio122/direction
;;

stop)
;;

reload)
    # Ensure exiting the backup (low power) mode (assertion time is about 1 second, until "PMTK010,001" resp. "STARTUP")
    echo "1" > /sys/class/gpio/gpio122/value
    sleep 2
    echo "0" > /sys/class/gpio/gpio122/value
    # Pulse GNSS_RESET reset
    echo "1" > /sys/class/gpio/gpio124/value
    sleep 0.1
    echo "0" > /sys/class/gpio/gpio124/value
    # In case perpetual backup (low power) mode was active, wait for some time
    # because reloading the gps.service handles both the FORCE_ON and RESET pin
    # which will result in two consecutive STARTUP and EPO-requested notifications
    sleep 2
;;

*)
    echo "Usage $0 {start|stop|reload}"
    exit
esac
