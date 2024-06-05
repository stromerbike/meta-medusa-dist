#!/bin/dash

NAME=can0
DESC="Initialization of can0 interface"

case $1 in
start)
    # /sys/devices/platform/soc/2000000.aips-bus/2094000.flexcan/net/can0/
    #while [ ! -d "/sys/devices/soc0/soc/2000000.aips-bus/2094000.flexcan/net/can0" ];
    #do
    #    sleep 1
    #done
    ip link set can0 up type can bitrate 250000 restart-ms 5000
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
