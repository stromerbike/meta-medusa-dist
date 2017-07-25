#! /bin/bash

NAME=mnt-rfs
DESC="Mounts the data partitions"

case $1 in
start)
    mount -t ubifs /dev/ubi0_2 /mnt/ubi2
    mount -t ubifs /dev/ubi0_3 /mnt/ubi3
;;

stop)
    umount /mnt/ubi2
    umount /mnt/ubi3
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
