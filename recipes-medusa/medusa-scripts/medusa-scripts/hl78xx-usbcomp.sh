#!/bin/bash

if lsusb -d 1519:0020; then
    echo "HL85xxx in USB mode detected"
elif lsusb -d 1199:c001; then
    echo "HL78xx in USB mode detected"
    if ! fuser -s /dev/ttyACM0; then
        rm -fv /var/lock/LCK..ttyACM0
    fi
    KUSBCOMP=$(echo -e "AT+KUSBCOMP?\r" | timeout -s KILL 2 microcom -t 1000 /dev/ttyACM0 | grep +KUSBCOMP:)
    if [ $? -eq 0 ]; then
        if [[ $KUSBCOMP =~ \+KUSBCOMP:\ 1,1,2,3 ]]; then
            echo "USB mode with desired interface assignments: $KUSBCOMP"
        else
            echo "USB mode with undesired interface assignments: $KUSBCOMP"
            echo -e "AT+KUSBCOMP=1,1,2,3\r" | timeout -s KILL 2 microcom -t 1000 /dev/ttyACM0 >/dev/null
            KUSBCOMP=$(echo -e "AT+KUSBCOMP?\r" | timeout -s KILL 2 microcom -t 1000 /dev/ttyACM0 | grep +KUSBCOMP:)
            if [ $? -eq 0 ]; then
                if [[ $KUSBCOMP =~ \+KUSBCOMP:\ 1,1,2,3 ]]; then
                    echo "Interface assigments adjusted to $KUSBCOMP"
                    echo "Resetting module via command"
                    echo -e "AT+CFUN=1,1\r" | timeout -s KILL 2 microcom -t 1000 /dev/ttyACM0
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
        echo "No response received via ttyACM0"
        echo "Interface assignments are possibly set to +KUSBCOMP=1,0,0,0"
        KUSBCOMP=$(echo -e "AT+KUSBCOMP?\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 /dev/ttymxc7 | grep +KUSBCOMP:)
        if [ $? -eq 0 ]; then
            echo "Interface assignments $KUSBCOMP"
            if echo -e "AT+KUSBCOMP=1,1,2,3\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 /dev/ttymxc7 | grep AT+KUSBCOMP=1,1,2,3; then
                echo "USB mode activated. Resetting module via command."
                echo -e "AT+CFUN=1,1\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 /dev/ttymxc7
                exit 0
            else
                echo "USB mode could not be activated"
                exit 11
            fi
        else
            echo "Interface assignments could not be read via ttymxc7"
            exit 11
        fi
    fi
else
    CGMR=$(echo -e "AT+CGMR\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 /dev/ttymxc7 | grep ^HL78)
    if [[ $CGMR =~ HL78 ]]; then
        echo "HL78xx (${CGMR//$'\r'/}) in UART mode detected. Issuing AT+KUSBCOMP=1,1,2,3."
        if echo -e "AT+KUSBCOMP=1,1,2,3\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 /dev/ttymxc7 | grep AT+KUSBCOMP=1,1,2,3; then
            echo "USB mode activated. Resetting module via command."
            echo -e "AT+CFUN=1,1\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 /dev/ttymxc7
            exit 0
        else
            echo "USB mode could not be activated"
            exit 11
        fi
    else
        echo "No HL78xx in UART mode detected. Resetting module via reset pin."
        systemctl reload gsm
        exit 11
    fi
fi
