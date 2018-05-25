#!/bin/dash

NAME=mnt-data
DESC="Mount the data partitions"

case $1 in
start)
    mount -t ubifs /dev/ubi0_2 /mnt/data
    mount -t ubifs /dev/ubi0_3 /mnt/data_backup
;;

stop)
    umount /mnt/data
    umount /mnt/data_backup
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
