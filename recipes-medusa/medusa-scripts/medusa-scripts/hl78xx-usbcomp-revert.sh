#!/bin/bash

source /etc/scripts/hlxxxx-common.sh

INTERFACE="ttyACM0"

if lsusb -d 1519:0020; then
    echo "HL85xxx in USB mode detected"
elif lsusb -d 1199:c001; then
    echo "HL78xx in USB mode detected"
    prepareComport
    KUSBCOMP=$(echo -e "AT+KUSBCOMP?\r" | timeout -s KILL 2 microcom -t 1000 "/dev/$INTERFACE" | grep +KUSBCOMP:)
    if [ $? -eq 0 ]; then
        cleanupComport
        if [[ $KUSBCOMP =~ \+KUSBCOMP:\ 1,1,2,3 ]]; then
            echo "USB mode with desired interface assignments: $KUSBCOMP"
            echo "UART mode activation issued"
            prepareComport
            echo -e "AT+KUSBCOMP=0\r" | timeout -s KILL 2 microcom -t 1000 "/dev/$INTERFACE" >/dev/null
            cleanupComport
            echo "Resetting module via command"
            prepareComport
            echo -e "AT+CFUN=1,1\r" | timeout -s KILL 2 microcom -t 1000 "/dev/$INTERFACE"
            cleanupComport
            exit 0
        else
            echo "USB mode with undesired interface assignments: $KUSBCOMP"
            echo "Run hl78xx-usbcomp.sh first"
            exit 11
        fi
    else
        cleanupComport
        echo "No response received via $INTERFACE"
        echo "Run hl78xx-usbcomp.sh first"
        exit 11
    fi
else
    echo "No HL78xx in USB mode detected."
    echo "Run hl78xx-usbcomp.sh first"
fi
