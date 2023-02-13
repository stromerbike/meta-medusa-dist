#!/bin/dash

NAME=can0
DESC="Initialization of can0 interface"

case $1 in
start)
    # CAN_SILENT
    # GPIO5 IO09 => (5 - 1) * 32 + 9 = 137
    # Remark: Pin compatible CAN transceivers to the TCAN1051 such as the TCAN1042
    # or MAX13054 with a standby feature need their STBY input driven low to work.
    test -e /sys/class/gpio/gpio137 || echo "137" > /sys/class/gpio/export
    echo "low" > /sys/class/gpio/gpio137/direction

    while [ ! -d "/sys/devices/soc0/soc/2000000.aips-bus/2094000.flexcan/net/can0" ];
    do
        sleep 1
    done
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
