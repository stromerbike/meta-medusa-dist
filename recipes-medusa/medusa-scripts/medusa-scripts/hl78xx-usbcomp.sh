#!/bin/bash

source /etc/scripts/hlxxxx-common.sh

INTERFACE="ttymxc7"

if lsusb -d 1519:0020; then
    echo "HL85xxx in USB mode detected"
    exit 0
elif lsusb -d 1199:c001; then
    echo "HL78xx in USB mode detected"
    INTERFACE="ttyACM0"
    prepareComport
    KUSBCOMP=$(echo -e "AT+KUSBCOMP?\r" | timeout -s KILL 2 microcom -t 1000 "/dev/$INTERFACE" | grep +KUSBCOMP:)
    cleanupComport
    if [ $? -eq 0 ]; then
        if [[ $KUSBCOMP =~ \+KUSBCOMP:\ 1,1,2,3 ]]; then
            echo "USB mode with desired interface assignments: $KUSBCOMP"
            exit 0
        else
            echo "USB mode with undesired interface assignments: $KUSBCOMP"
            prepareComport
            echo -e "AT+KUSBCOMP=1,1,2,3\r" | timeout -s KILL 2 microcom -t 1000 "/dev/$INTERFACE" >/dev/null
            cleanupComport
            prepareComport
            KUSBCOMP=$(echo -e "AT+KUSBCOMP?\r" | timeout -s KILL 2 microcom -t 1000 "/dev/$INTERFACE" | grep +KUSBCOMP:)
            cleanupComport
            if [ $? -eq 0 ]; then
                if [[ $KUSBCOMP =~ \+KUSBCOMP:\ 1,1,2,3 ]]; then
                    echo "Interface assigments adjusted to $KUSBCOMP"
                    echo "Resetting module via command"
                    prepareComport
                    echo -e "AT+CFUN=1,1\r" | timeout -s KILL 2 microcom -t 1000 "/dev/$INTERFACE"
                    cleanupComport
                    exit 0
                else
                    echo "Interface assignments could not be adjusted correctly ($KUSBCOMP)"
                    exit 11
                fi
            else
                echo "Interface assignments could not be adjusted"
                exit 11
            fi
        fi
    else
        echo "No response received via $INTERFACE"
        echo "Interface assignments are possibly set to +KUSBCOMP=1,0,0,0"
        INTERFACE="ttymxc7"
        prepareComport
        KUSBCOMP=$(echo -e "AT+KUSBCOMP?\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 "/dev/$INTERFACE" | grep +KUSBCOMP:)
        cleanupComport
        if [ $? -eq 0 ]; then
            echo "Interface assignments $KUSBCOMP"
            prepareComport
            if echo -e "AT+KUSBCOMP=1,1,2,3\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 "/dev/$INTERFACE" | grep AT+KUSBCOMP=1,1,2,3; then
                cleanupComport
                echo "USB mode activated. Resetting module via command."
                prepareComport
                echo -e "AT+CFUN=1,1\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 "/dev/$INTERFACE"
                cleanupComport
                exit 0
            else
                cleanupComport
                echo "USB mode could not be activated"
                exit 11
            fi
        else
            echo "Interface assignments could not be read via $INTERFACE"
            exit 11
        fi
    fi
else
    prepareComport
    CGMR=$(echo -e "AT+CGMR\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 "/dev/$INTERFACE" | grep ^HL78)
    cleanupComport
    if [[ $CGMR =~ HL78 ]]; then
        echo "HL78xx (${CGMR//$'\r'/}) in UART mode detected. Issuing AT+KUSBCOMP=1,1,2,3."
        prepareComport
        if echo -e "AT+KUSBCOMP=1,1,2,3\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 "/dev/$INTERFACE" | grep AT+KUSBCOMP=1,1,2,3; then
            cleanupComport
            echo "USB mode activated. Resetting module via command."
            prepareComport
            echo -e "AT+CFUN=1,1\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 "/dev/$INTERFACE"
            cleanupComport
            exit 0
        else
            cleanupComport
            echo "USB mode could not be activated"
            exit 11
        fi
    else
        echo "No HL78xx in UART mode detected. Resetting module via reset pin."
        systemctl reload gsm
        exit 11
    fi
fi
