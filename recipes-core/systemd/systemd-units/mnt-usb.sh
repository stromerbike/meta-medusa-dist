#!/bin/dash

NAME=mnt-usb
DESC="Mounting of usb drive"

case $1 in
start)
    COUNTER=0
    while [ $COUNTER -lt 5 ];
    do
        COUNTER=$((COUNTER+1))
        if [ -e /dev/sda1 ]; then
            if mount /dev/sda1 /mnt/usb; then
                echo "Mounted sda1"
                exit 0
            fi
        fi
        sleep 1
    done
    # very few USB drives do not have a partition table and thus no sda1
    if mount /dev/sda /mnt/usb; then
        echo "Mounted sda instead"
        exit 0
    else
        echo "<3>Mounting of sda failed"
        exit 1
    fi
;;

stop)
    umount /mnt/usb || true
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
