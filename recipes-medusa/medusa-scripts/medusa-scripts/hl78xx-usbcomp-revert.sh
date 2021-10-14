#!/bin/bash

if lsusb -d 1519:0020; then
    echo "HL85xxx in USB mode detected"
elif lsusb -d 1199:c001; then
    echo "HL78xx in USB mode detected"
    if [ -e /dev/ttyACM0 ]; then
        fuser -k /dev/ttyACM0
    fi
    if [ -e /var/lock/LCK..ttyACM0 ]; then
        rm -fv /var/lock/LCK..ttyACM0
    fi
    KUSBCOMP=$(echo -e "AT+KUSBCOMP?\r" | timeout -s KILL 2 microcom -t 1000 /dev/ttyACM0 | grep +KUSBCOMP:)
    if [ $? -eq 0 ]; then
        if [[ $KUSBCOMP =~ \+KUSBCOMP:\ 1,1,2,3 ]]; then
            echo "USB mode with desired interface assignments: $KUSBCOMP"
            echo "UART mode activation issued"
            echo -e "AT+KUSBCOMP=0\r" | timeout -s KILL 2 microcom -t 1000 /dev/ttyACM0 >/dev/null
            echo "Resetting module via command"
            echo -e "AT+CFUN=1,1\r" | timeout -s KILL 2 microcom -t 1000 /dev/ttyACM0
            exit 0
        else
            echo "USB mode with undesired interface assignments: $KUSBCOMP"
            echo "Run hl78xx-usbcomp.sh first"
            exit 11
        fi
    else
        echo "No response received via ttyACM0"
        echo "Run hl78xx-usbcomp.sh first"
        exit 11
    fi
else
    echo "No HL78xx in USB mode detected."
    echo "Run hl78xx-usbcomp.sh first"
fi
