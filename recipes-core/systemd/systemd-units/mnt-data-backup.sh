#!/bin/dash

NAME=mnt-data-backup
DESC="Mount the backup data partition"

case $1 in
start)
    mount -t ubifs /dev/ubi0_3 /mnt/data_backup
;;

stop)
    umount /mnt/data_backup
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
