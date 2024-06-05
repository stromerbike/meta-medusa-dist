#!/bin/dash

NAME=mnt-usb
DESC="Mounting of usb drive"

case $1 in
start)
    COUNTER=0
    while [ $COUNTER -lt 5 ];
    do
        COUNTER=$((COUNTER+1))
        if [ -e /dev/sd*1 ]; then
            if mount -v /dev/sd*1 /mnt/usb; then
                exit 0
            fi
        fi
        sleep 1
    done
    # very few USB drives do not have a partition table and thus no sda1
    if mount -v /dev/sd* /mnt/usb; then
        exit 0
    else
        echo "<3>Mounting method for USB drives without partition table failed"
        exit 1
    fi
;;

stop)
    if df | grep "/mnt/usb"; then
        echo "Unmounting usb..."
        if umount /mnt/usb; then
            echo "...done"
        fi
    fi
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
