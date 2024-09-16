#!/bin/dash

NAME=can0
DESC="Initialization of can0 interface"

case $1 in
start)
    ip link set can0 type can bitrate 250000 restart-ms 5000
    ip link set can0 up
;;

stop)
    ip link set can0 down
;;

reload)
    ip link set can0 type can restart
;;

*)
    echo "Usage $0 {start|stop|reload}"
    exit
esac
