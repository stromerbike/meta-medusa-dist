#!/bin/dash

NAME=mnt-sda1
DESC="Mounting of sda1"

case $1 in
start)
    while true;
    do
        if mount /dev/sda1 /mnt/sda1; then
            break
        else
            echo "Failed. Retrying later..."
            sleep 1
        fi
    done
    sleep 1
;;

stop)
    umount /mnt/sda1
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
