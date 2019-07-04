#!/bin/dash

NAME=ble
DESC="Initialization of bluetooth chip"

case $1 in
start)
    # BLE_nON
    echo "499" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio499/direction
    echo "0" > /sys/class/gpio/gpio499/value

    # BLE_nSHUTD
    echo "120" > /sys/class/gpio/export
    echo "out" > /sys/class/gpio/gpio120/direction
    echo "1" > /sys/class/gpio/gpio120/value

    # hci0
    hciattach /dev/ttymxc2 texas

    # Bluetooth daemon "/usr/libexec/bluetooth/bluetoothd" needs to be started before the hci0 interface is up !!!
    hciconfig hci0 down
;;

stop)
    killall hciattach
    echo "0" > /sys/class/gpio/gpio120/value
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
