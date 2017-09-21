#!/bin/bash

NAME=mnt-rfs
DESC="Mount the data partitions"

case $1 in
start)
    mount -t ubifs /dev/ubi0_2 /mnt/ubi2
    mount -t ubifs /dev/ubi0_3 /mnt/ubi3
    mount -t ubifs /dev/ubi0_2 /mnt/data
    mount -t ubifs /dev/ubi0_3 /mnt/data_backup
;;

stop)
    umount /mnt/ubi2
    umount /mnt/ubi3
    umount /mnt/data
    umount /mnt/data_backup
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
