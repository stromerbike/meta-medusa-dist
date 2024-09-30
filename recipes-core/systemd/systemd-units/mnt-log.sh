#!/bin/dash

NAME=mnt-log
DESC="Mount the logging partition"

case $1 in
start)
    echo "Mounting logging partition..."
    if mount -t ubifs /dev/ubi0_3 /mnt/log; then
        echo "Testing writeability..."
        if touch /mnt/log/testfile; then
            echo "Cleaning up..."
            if rm /mnt/log/testfile; then
                echo "...done"
                exit 0
            fi
        fi
    fi
    echo "<3>...ERROR"

    umount -v -f /mnt/log || true
    echo "Creating an empty filesystem on /dev/ubi0_3..."
    if mkfs.ubifs -v -y /dev/ubi0_3; then
        echo "Re-mounting logging partition..."
        if mount -t ubifs /dev/ubi0_3 /mnt/log; then
            echo "...done"
            exit 0
        fi
    fi
    echo "<3>...ERROR"
;;

stop)
    echo "Unmounting logging partition..."
    umount /mnt/log
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
