#!/bin/dash

NAME=mnt-rfs
DESC="Mount the inactive rfs partition"

case $1 in
start)
    if df / | grep 'ubi0:part0'; then
        echo "Mounting inactive rfs partition ubi0_1..."
        mount -t ubifs /dev/ubi0_1 /mnt/rfs_inactive
    elif df / | grep 'ubi0:part1'; then
        echo "Mounting inactive rfs partition ubi0_0..."
        mount -t ubifs /dev/ubi0_0 /mnt/rfs_inactive
    else
        echo "Active partition could not be determined"
    fi
;;

stop)
    echo "Unmounting inactive rfs partition..."
    umount /mnt/rfs_inactive
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
