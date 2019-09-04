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
    if df | grep "/mnt/usb"; then
        if df -T | grep "/mnt/usb" | grep "fuseblk"; then
            echo "Unmounting (-f) usb..."
            if umount -f /mnt/usb; then
                echo "...done"
            fi
        else
            echo "Unmounting usb..."
            if umount /mnt/usb; then
                echo "...done"
            fi
        fi
    fi
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
