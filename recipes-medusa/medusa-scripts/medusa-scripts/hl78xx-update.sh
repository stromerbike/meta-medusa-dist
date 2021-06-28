#!/bin/bash

SEND_COMMAND=""
SEND_INTERFACE=""

if lsusb -d 1519:0020; then
    echo "HL85xxx in USB mode detected"
    exit 0
elif lsusb -d 1199:c001; then
    COUNTER=0
    while [ $COUNTER -lt 5 ];
    do
        let COUNTER=COUNTER+1
        if [ -e /dev/ttyACM1 ]; then
            fuser -k /dev/ttyACM1
        fi
        if [ -e /var/lock/LCK..ttyACM1 ]; then
            rm -fv /var/lock/LCK..ttyACM1
        fi
        CGMR=$(echo -e "AT+CGMR\r" | timeout -s KILL 2 microcom -t 1000 "/dev/ttyACM1" | grep ^HL78)
        if [ ! -z "$CGMR" ]; then
            echo "HL78xx in USB mode detected: $CGMR"
            SEND_COMMAND="microcom -t 1000"
            SEND_INTERFACE="ttyACM1"
            break
        fi
    done
    if [ -z "$SEND_COMMAND" ] && [ -z "$SEND_INTERFACE" ]; then
        echo "HL78xx in USB mode not responsive"
        exit 11
    fi
else
    CGMR=$(echo -e "AT+CGMR\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 /dev/ttymxc7 | grep ^HL78)
    if [ ! -z "$CGMR" ]; then
        echo "HL78xx in UART mode detected: $CGMR"
        SEND_COMMAND="picocom -qr -b 115200 -f h -x 1000"
        SEND_INTERFACE="ttymxc7"
    else
        echo "No answer via UART received"
        exit 11
    fi
fi

if [ ! -z "$SEND_COMMAND" ] && [ ! -z "$SEND_INTERFACE" ]; then
    CGMR=$(echo -e "AT+CGMR\r" | timeout -s KILL 2 $SEND_COMMAND "/dev/$SEND_INTERFACE" | grep ^HL78)
    if [[ $CGMR =~ ^HL78([0-9]+).([0-9]+.[0-9]+.[0-9]+.[0.9]+) ]]; then
        MODULE_VARIANT="${BASH_REMATCH[1]}"
        CURRENT_REVISION="${BASH_REMATCH[2]}"
        echo "Current HL78$MODULE_VARIANT revision: $CURRENT_REVISION"
        if cd /lib/firmware/sierra-wireless/ && sha256sum -c SHA256SUMS; then
            echo "Checksums valid"
            UPDATE_FILE="$(stat -c %n HL78${MODULE_VARIANT}_${CURRENT_REVISION}_to_*)"
            if [ $? -eq 0 ]; then
                echo "Applicable update file: $UPDATE_FILE"
                UPDATE_FILE_SIZE="$(stat -c %s $UPDATE_FILE)"
                echo "Update file size: $UPDATE_FILE_SIZE bytes"
                if echo -e "AT+WDSI=4470\r" | timeout -s KILL 2 $SEND_COMMAND "/dev/$SEND_INTERFACE" | grep OK; then
                    echo "Activated all indications"
                else
                    echo "Could not activate all indications"
                    exit 11
                fi
                if echo -e "ATE1\r" | timeout -s KILL 2 $SEND_COMMAND "/dev/$SEND_INTERFACE" | grep OK; then
                    echo "Activated echo"
                else
                    echo "Could not activate echo"
                    exit 11
                fi
                if echo -e "AT+WDSD=$UPDATE_FILE_SIZE\r" | timeout -s KILL 2 $SEND_COMMAND "/dev/$SEND_INTERFACE" | grep AT+WDSD=$UPDATE_FILE_SIZE; then
                    echo "Sent file size"
                else
                    echo "Could not send file size"
                    exit 11
                fi
                if sx -vv --1k --xmodem $UPDATE_FILE < "/dev/$SEND_INTERFACE" > "/dev/$SEND_INTERFACE"; then
                    echo "Sent file"
                else
                    echo "Could not send file"
                    exit 11
                fi
                sleep 5
                if echo -e "AT+WDSR=4\r" | timeout -s KILL 2 $SEND_COMMAND "/dev/$SEND_INTERFACE" | grep "+WDSI: 14"; then
                    echo "Accepted the installation and update will be launched"
                    echo "Waiting 180s for the installation and reboot to complete"
                    sleep 180
                    echo "Reading back revision"
                    CGMR=$(echo -e "AT+CGMR\r" | timeout -s KILL 2 $SEND_COMMAND "/dev/$SEND_INTERFACE" | grep ^HL78)
                    if [[ $CGMR =~ ^HL78([0-9]+).([0-9]+.[0-9]+.[0-9]+.[0.9]+) ]]; then
                        NEW_REVISION="${BASH_REMATCH[2]}"
                        if [[ "$NEW_REVISION" != "$CURRENT_REVISION" ]]; then
                            echo "Revision has changed to $NEW_REVISION"
                            exit 0
                        else
                            echo "Revision has not changed from $CURRENT_REVISION"
                            exit 11
                        fi
                    else
                        echo "Could not read back revision"
                        exit 11
                    fi
                else
                    echo "Could not accept the installation and update will not be launched"
                    exit 11
                fi
            else
                echo "No applicable update file found"
                exit 0
            fi
        else
            echo "Checksums not valid"
            exit 11
        fi
    else
        echo "Current revision: $CGMR"
    fi
fi
