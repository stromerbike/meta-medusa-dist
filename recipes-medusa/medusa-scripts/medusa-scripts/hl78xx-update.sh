#!/bin/bash

SEND_COMMAND=""
SEND_INTERFACE=""

if lsusb -d 1519:0020; then
    echo "HL85xxx in USB mode detected"
    exit 0
elif lsusb -d 1199:c001; then
    echo "HL78xx in USB mode detected"
    # Remark: Update in USB mode not activated because USB mode is used for normal operation and bound to udev rules.
    #SEND_COMMAND="microcom -t 1000"
    #SEND_INTERFACE="/dev/ttyACM1"
else
    CGMR=$(echo -e "AT+CGMR\r" | picocom -qr -b 115200 -f h -x 1000 /dev/ttymxc7 | grep ^HL78)
    if [ ! -z "$CGMR" ]; then
        echo "HL78xx in UART mode detected: $CGMR"
        SEND_COMMAND="picocom -qr -b 115200 -f h -x 1000"
        SEND_INTERFACE="/dev/ttymxc7"
    fi
fi

if [ ! -z "$SEND_COMMAND" ] && [ ! -z "$SEND_INTERFACE" ]; then
    CGMR=$(echo -e "AT+CGMR\r" | $SEND_COMMAND $SEND_INTERFACE | grep ^HL78)
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
                if echo -e "AT+WDSI=4470\r" | $SEND_COMMAND $SEND_INTERFACE | grep OK; then
                    echo "Activated all indications"
                else
                    echo "Could not activate all indications"
                    exit 11
                fi
                if echo -e "AT+WDSD=$UPDATE_FILE_SIZE\r" | $SEND_COMMAND $SEND_INTERFACE | grep AT+WDSD=$UPDATE_FILE_SIZE; then
                    echo "Sent file size"
                else
                    echo "Could not send file size"
                    exit 11
                fi
                if sx -vv --1k --xmodem $UPDATE_FILE < $SEND_INTERFACE > $SEND_INTERFACE; then
                    echo "Sent file"
                else
                    echo "Could not send file"
                    exit 11
                fi
                sleep 5
                if echo -e "AT+WDSR=4\r" | $SEND_COMMAND $SEND_INTERFACE | grep "+WDSI: 14"; then
                    echo "Accepted the installation and update will be launched"
                    echo "Waiting 120s for the installation and reboot to complete"
                    sleep 120
                    echo "Reading back revision"
                    CGMR=$(echo -e "AT+CGMR\r" | $SEND_COMMAND $SEND_INTERFACE | grep ^HL78)
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
