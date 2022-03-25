#!/bin/dash

NAME=gsm
DESC="Initialization of gsm chip"

case $1 in
start)
    # GSM_ON_N (to gate of V13 on PWR_ON_N = ~GSM_ON_N)
    # GPIO5 IO05 => (5 - 1) * 32 + 5 = 133
    echo "133" > /sys/class/gpio/export
    echo "low" > /sys/class/gpio/gpio133/direction
    # GSM_RESET (to gate of V10 on RESET_IN_N = ~GSM_RESET)
    # GPIO5 IO00 => (5 - 1) * 32 = 128
    echo "128" > /sys/class/gpio/export
    echo "high" > /sys/class/gpio/gpio128/direction
    # 3V7_ON (to enable pin of U22)
    echo "497" > /sys/class/gpio/export
    echo "high" > /sys/class/gpio/gpio497/direction
    # Wait for 3V7 voltage to rise (U22 is configured via C162 to soft start over 16ms)
    sleep 0.2
    # Release GSM_RESET to start HL78xx (HL85xx should not care)
    echo "0" > /sys/class/gpio/gpio128/value
    # Assert GSM_ON_N to start HL85xx (HL78xx should not care)
    echo "1" > /sys/class/gpio/gpio133/value
    # Probe UART driver
    sleep 0.5
    modprobe imx6ul_mod_uart
;;

stop)
    # Remove UART driver
    rmmod imx6ul_mod_uart
    # Disable 3V7 voltage
    echo "0" > /sys/class/gpio/gpio497/value
;;

reload)
    # Pulse GSM reset (minimum assertion time is 10ms for HL85xx and 100us for HL78xx)
    echo "1" > /sys/class/gpio/gpio128/value
    sleep 0.1
    echo "0" > /sys/class/gpio/gpio128/value
;;

*)
    echo "Usage $0 {start|stop|reload}"
    exit
esac
