#!/bin/dash

NAME=ble
DESC="Initialization of bluetooth chip"

case $1 in
start)
    # BLE_nON
    test -e /sys/class/gpio/gpio499 || echo "499" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio499/direction
    echo "0" > /sys/class/gpio/gpio499/value

    # BLE_nSHUTD
    test -e /sys/class/gpio/gpio120 || echo "120" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio120/direction
    echo "1" > /sys/class/gpio/gpio120/value

    # hci0
    hciattach /dev/ttymxc2 texas

    # Bluetooth daemon "/usr/libexec/bluetooth/bluetoothd" needs to be started before the hci0 interface is up !!! (ScUr: Not sure if still applicable)
    hciconfig hci0 down
;;

stop)
    killall hciattach
    echo "0" > /sys/class/gpio/gpio120/value
;;

reload)
    killall hciattach
    hciconfig hci0 down
    btmgmt power off
    
    # do BLE_nSHUTD reset
    echo "0" > /sys/class/gpio/gpio120/value
    sleep 0.1
    echo "1" > /sys/class/gpio/gpio120/value

    # hci0
    hciattach /dev/ttymxc2 texas

    btmgmt power on
    hciconfig hci0 up
;;

*)
    echo "Usage $0 {start|stop|reload}"
    exit
esac
