#! /bin/bash

NAME=zram
DESC="Initialization of zram device"

case $1 in
start)
    modprobe zram
    echo $((1024*1024*1024)) > /sys/block/zram0/disksize
    echo $((384*1024*1024)) > /sys/block/zram0/mem_limit
    mkfs.ext4 /dev/zram0
    mount /dev/zram0 /mnt/zram
;;

stop)
    umount /mnt/zram
    modprobe -r zram
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
