#!/bin/bash

source /etc/scripts/hlxxxx-common.sh

CGMR=""
COMMAND=""
INTERFACE="ttyACM1" # The update via XMODEM, resp. AT+WDSD= only works on the "AT/PPP data port".

if lsusb -d 1519:0020; then
    echo "HL85xxx in USB mode detected"
    exit 0
elif lsusb -d 1199:c001; then
    # When wvdial has previously been active on the interface to be used,
    # the first command might fail, because data mode is still active.
    COUNTER=0
    while [ $COUNTER -lt 5 ];
    do
        let COUNTER=COUNTER+1
        prepareComport
        CGMR=$(echo -e "AT+CGMR\r" | timeout -s KILL 3 microcom -t 2000 "/dev/$INTERFACE" | grep ^HL78)
        cleanupComport
        if [ ! -z "$CGMR" ]; then
            echo "HL78xx in USB mode detected: $CGMR"
            COMMAND="timeout -s KILL 3 microcom -t 2000"
            break
        fi
    done
    if [ -z "$CGMR" ]; then
        echo "HL78xx in USB mode not responsive"
        exit 11
    fi
else
    INTERFACE="ttymxc7"
    prepareComport
    CGMR=$(echo -e "AT+CGMR\r" | timeout -s KILL 3 picocom -qr -b 115200 -f h -x 2000 "/dev/$INTERFACE" | grep ^HL78)
    cleanupComport
    if [ ! -z "$CGMR" ]; then
        echo "HL78xx in UART mode detected: $CGMR"
        COMMAND="timeout -s KILL 3 picocom -qr -b 115200 -f h -x 2000"
    else
        echo "No answer via UART received"
        exit 11
    fi
fi

echo "COMMAND: $COMMAND"
echo "INTERFACE: $INTERFACE"

if [ ! -z "$CGMR" ]; then
    prepareComport
    CGMR=$(echo -e "AT+CGMR\r" | $COMMAND "/dev/$INTERFACE" | grep ^HL78)
    cleanupComport
    if [[ $CGMR =~ ^HL78([0-9]+).(([0-9]+).([0-9]+).([0-9]+).([0-9]+)) ]]; then
        MODULE_VARIANT="${BASH_REMATCH[1]}"
        CURRENT_REVISION="${BASH_REMATCH[2]}"
        # Some firmware versions have more than one digit per position in their version.
        # For working nummerical comparisons, "0"'s are prepended for each position.
        CURRENT_REVISION_ZEROED="$(printf "%03d%03d%03d%03d" ${BASH_REMATCH[3]} ${BASH_REMATCH[4]} ${BASH_REMATCH[5]} ${BASH_REMATCH[6]})"
        echo "Current HL78$MODULE_VARIANT revision: $CURRENT_REVISION ($CURRENT_REVISION_ZEROED)"
        if cd /lib/firmware/sierra-wireless/ && sha256sum -c SHA256SUMS; then
            echo "Checksums valid"
            UPDATE_FILE="$(stat -c %n HL78${MODULE_VARIANT}_${CURRENT_REVISION}_to_*)"
            if [ $? -eq 0 ]; then
                echo "Applicable update file: $UPDATE_FILE"
                UPDATE_FILE_SIZE="$(stat -c %s $UPDATE_FILE)"
                echo "Update file size: $UPDATE_FILE_SIZE bytes"
                prepareComport
                if echo -e "AT+WDSI=4470\r" | $COMMAND "/dev/$INTERFACE" | grep OK; then
                    cleanupComport
                    echo "Activated all indications"
                else
                    cleanupComport
                    echo "Could not activate all indications"
                    exit 11
                fi
                prepareComport
                if echo -e "AT+WDSD=$UPDATE_FILE_SIZE\r" | $COMMAND "/dev/$INTERFACE" | grep -m1 -a $'\x15'; then
                    cleanupComport
                    echo "Sent file size and received <NACK> character(s)"
                else
                    cleanupComport
                    echo "Could not send file size or did not receive <NACK> character(s)"
                    exit 11
                fi
                prepareComport
                # Remark: X-MODEM transfers with 1024 byte blocks may fail for given delta image sizes (EURY-4127, fixed in 4.6.9.4).
                #         The following HL7802 firmwares have been tested in this regard
                #         (the calculation method EURY-4127 does not always seem valid):
                #         - HL7802_4.3.9.0_to_4.4.14.0_allBin_nbIOT11_sig11.ua: --1k works
                #         - HL7802_4.3.9.0_to_4.6.9.4_allBin_nbIOT11_sig11.ua:  --1k does not work (ERROR)
                #         - HL7802_4.4.14.0_to_4.7.1.0_allBin_nbIOT11_sig11.ua: --1k works
                #         - HL7802_4.4.14.0_to_4.6.9.4_allBin_nbIOT11_sig11.ua: --1k does not work (CME ERROR 3)
                #         - HL7802_4.4.14.0_to_4.5.4.0_allBin_nbIOT11_sig11.ua: --1k works
                #         - HL7802_4.5.4.0_to_4.6.9.4_allBin_nbIOT11_sig11.ua:  --1k works
                #         - HL7802_4.5.4.0_to_4.7.1.0_allBin_nbIOT11_sig11.ua:  --1k works
                #         - HL7802_4.6.9.4_to_4.7.1.0_allBin_nbIOT11_sig11.ua:  --1k works (since EURY-4127 fixed)
                #
                #         To make use of the considerably faster 1024 byte block transfer, an update to 4.6.9.4+
                #         over intermediate versions (4.4.14.0 -> 4.5.4.0 -> 4.6.9.4) should be strongly favored
                #         if no appropriate file for a direct update is available (some files were shared by Sierra
                #         Wireless upon request).
                if sx -vv --1k --xmodem $UPDATE_FILE < "/dev/$INTERFACE" > "/dev/$INTERFACE"; then
                    cleanupComport
                    echo "Sent file"
                else
                    cleanupComport
                    echo "Could not send file"
                    exit 11
                fi
                sleep 5
                prepareComport
                if echo -e "AT+WDSR=4\r" | $COMMAND "/dev/$INTERFACE" | grep "+WDSI: 14"; then
                    cleanupComport
                    echo "Accepted the installation and update will be launched"
                    echo "Waiting up to 300s for the installation to complete"
                    # Upon appearance of the of the ttyACM1 (symlinked to ttyGSM1) interface,
                    # it will be used by the wvdial service and should not be used in this script.
                    # Therefore use the cgmr value read out by the gsm-module service.
                    if [[ $INTERFACE == ttyACM* ]]; then
                        if [ -f /tmp/cgmr ]; then
                            rm -fv /tmp/cgmr
                        fi
                    fi
                    EXPECTED_WAIT=60
                    case "$UPDATE_FILE" in
                        *4.4.14.0_to_4.5.4.0*)
                            EXPECTED_WAIT=26
                            ;;
                        *4.4.14.0_to_4.7.1.0*)
                            EXPECTED_WAIT=40
                            ;;
                        *4.5.4.0_to_4.6.9.4*)
                            EXPECTED_WAIT=38
                            ;;
                        *4.5.4.0_to_4.7.1.0*)
                            EXPECTED_WAIT=40
                            ;;
                        *4.6.9.4_to_4.7.1.0*)
                            EXPECTED_WAIT=44
                            ;;
                    esac
                    COUNTER=0
                    while [ $COUNTER -lt 60 ];
                    do
                        COUNTER=$((COUNTER+1))
                        sleep 3
                        if [[ $INTERFACE == ttyACM* ]]; then
                            CGMR="$(cat /tmp/cgmr 2> /dev/null)"
                            sleep 2
                        else
                            prepareComport
                            CGMR=$(echo -e "AT+CGMR\r" | $COMMAND "/dev/$INTERFACE" | grep ^HL78)
                            cleanupComport
                        fi
                        if [[ $CGMR =~ ^HL78([0-9]+).([0-9]+.[0-9]+.[0-9]+.[0-9]+) ]]; then
                            NEW_REVISION="${BASH_REMATCH[2]}"
                            if [[ "$NEW_REVISION" != "$CURRENT_REVISION" ]]; then
                                echo "Revision has changed to $NEW_REVISION"
                                /etc/scripts/hl78xx-update-check.sh $CGMR
                                if [ $? -eq 1 ]; then
                                    # Raise a "Package not installed" in case there is still an applicable update file.
                                    exit 65
                                else
                                    exit 0
                                fi
                            else
                                echo "Revision has not changed from $CURRENT_REVISION"
                                exit 11
                            fi
                        else
                            PROGRESS=$((COUNTER*100/EXPECTED_WAIT))
                            if [ "$PROGRESS" -gt 99 ]; then
                                PROGRESS=99
                            fi
                            echo "Not yet complete: $PROGRESS% (act: $((COUNTER*5))s, exp: $((EXPECTED_WAIT*5))s)"
                        fi
                    done
                    echo "Could not read back revision"
                    exit 11
                else
                    cleanupComport
                    echo "Could not accept the installation and update will not be launched"
                    exit 11
                fi
            else
                echo "No applicable update file found"
                if [ $((10#$CURRENT_REVISION_ZEROED)) -ge 4004014000 ]; then # 4.4.14.0 and newer
                    echo "Current revision is new enough"
                    exit 0
                else
                    echo "Current revision is too old"
                    exit 11
                fi
            fi
        else
            echo "Checksums not valid"
            exit 11
        fi
    else
        echo "Current revision: $CGMR"
    fi
fi
