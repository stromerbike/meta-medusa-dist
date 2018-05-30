#!/bin/dash

NAME=mnt-data
DESC="Mount the data partition"

case $1 in
start)
    mount -t ubifs /dev/ubi0_2 /mnt/data
;;

stop)
    umount /mnt/data
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
