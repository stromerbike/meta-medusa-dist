#!/bin/dash

NAME=ble
DESC="Initialization of bluetooth chip"

case $1 in
start)
    # BLE_nON
    test -e /sys/class/gpio/gpio515 || echo "515" > /sys/class/gpio/export
    echo "low" > /sys/class/gpio/gpio515/direction

    # BLE_nSHUTD
    test -e /sys/class/gpio/gpio120 || echo "120" > /sys/class/gpio/export
    echo "high" > /sys/class/gpio/gpio120/direction

    # hci0
    # Despite 0001-tools-hciattach-Increase-timeout-for-TI-specific-ini.patch in place
    # (with the timeout made even bigger: 1000ms) cases have still been observed where
    # hciattach fails. Retrials shall help to alleviate the issue.
    COUNTER=0
    while [ $COUNTER -lt 5 ];
    do
        COUNTER=$((COUNTER+1))
        if hciattach /dev/ttymxc2 texas; then
            break
        fi
        sleep 3
    done

    # Bluetooth daemon "/usr/libexec/bluetooth/bluetoothd" needs to be started before the hci0 interface is up !!! (ScUr: Not sure if still applicable)
    hciconfig hci0 down
;;

stop)
    # Turn off the Bluetooth radio using btmgmt ('echo -e "power off\nquit\n" | bluetoothctl' could also be used)
    script -qc "btmgmt power off" /dev/null

    # Kill all existing hciattach processes (will also take down hci interface)
    killall hciattach

    # BLE_nSHUTD (put device in low power mode and do internal reset)
    echo "0" > /sys/class/gpio/gpio120/value
;;

reload)
    # Turn off the Bluetooth radio using btmgmt ('echo -e "power off\nquit\n" | bluetoothctl' could also be used)
    script -qc "btmgmt power off" /dev/null

    # Kill all existing hciattach processes (will also take down hci interface)
    killall hciattach

    # BLE_nSHUTD (put device in low power mode and do internal reset)
    echo "0" > /sys/class/gpio/gpio120/value
    # Wait (minimum time for nSHUT_DOWN low to reset the device: 5ms)
    sleep 0.1
    # BLE_nSHUTD (bring device out of low power mode)
    echo "1" > /sys/class/gpio/gpio120/value

    # Attach the HCI device using hciattach
    hciattach /dev/ttymxc2 texas

    # Power on the Bluetooth radio using btmgmt
    btmgmt power on
;;

*)
    echo "Usage $0 {start|stop|reload}"
    exit
esac
