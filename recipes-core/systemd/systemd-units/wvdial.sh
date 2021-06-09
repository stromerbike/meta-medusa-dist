#!/bin/bash

UNRESPONSIVE_MODULE_COUNT_LIMIT=5

UNSUCCESSFUL_DIALIN_COUNT_LIMIT=5
UNSUCCESSFUL_DIALIN_COUNT=0

INTERFACE="ttyGSM0"
NETWORK_REGISTRATION_EXEC_COMMAND="CREG=2"
NETWORK_REGISTRATION_READ_COMMAND="CREG"
WVDIAL_CONFIG_SECTION=""

if lsusb -d 1519:0020 >/dev/null; then
    echo "HL85xxx in USB mode detected"
elif lsusb -d 1199:c001 >/dev/null; then
    echo "HL78xx in USB mode detected"
    INTERFACE="ttyGSM1"
    NETWORK_REGISTRATION_EXEC_COMMAND="CEREG=5"
    NETWORK_REGISTRATION_READ_COMMAND="CEREG"
    WVDIAL_CONFIG_SECTION="hl78xx-usb"
fi

echo "INTERFACE: $INTERFACE"
echo "NETWORK_REGISTRATION_EXEC_COMMAND: $NETWORK_REGISTRATION_EXEC_COMMAND"
echo "NETWORK_REGISTRATION_READ_COMMAND: $NETWORK_REGISTRATION_READ_COMMAND"
echo "WVDIAL_CONFIG_SECTION: $WVDIAL_CONFIG_SECTION"

function handleStaleLock() {
    if ! fuser -s "/dev/$INTERFACE"; then
        rm -fv "/var/lock/LCK..$INTERFACE"
    fi
}

function resetSoft() {
    echo "Attempting to soft reset module..."
    handleStaleLock
    if echo -e "AT+CFUN=1,1\r" | microcom -t 500 "/dev/$INTERFACE" | grep -m1 OK; then
        echo "...done"
    else
        echo "...error"
    fi
}

while true;
do
    echo "Enabling network registration unsolicited result code"
    handleStaleLock
    echo -e "AT+$NETWORK_REGISTRATION_EXEC_COMMAND\r" | microcom -t 2000 "/dev/$INTERFACE"

    echo "Waiting for network registration to home network or roaming..."
    UNRESPONSIVE_MODULE_COUNT=0
    while true;
    do
        handleStaleLock
        RESPONSE="$(echo -e "AT+$NETWORK_REGISTRATION_READ_COMMAND?\r" | microcom -t 5000 "/dev/$INTERFACE")"

        if [[ $RESPONSE =~ \+CE?REG:\ (0|1|2|3|4|5),(1|5) ]]; then
            echo "...registration done:"
            echo "$RESPONSE"
            UNRESPONSIVE_MODULE_COUNT=0
            break
        elif [[ "$RESPONSE" =~ (\+CE?REG:\ [^$'\r\n']+) ]]; then
            echo "${BASH_REMATCH[1]}"
            UNRESPONSIVE_MODULE_COUNT=0
        else
            if [ "$UNRESPONSIVE_MODULE_COUNT" -lt "$UNRESPONSIVE_MODULE_COUNT_LIMIT" ]; then
                UNRESPONSIVE_MODULE_COUNT=$((UNRESPONSIVE_MODULE_COUNT + 1))
                echo "Module unresponsive $UNRESPONSIVE_MODULE_COUNT time(s in a row)"
            else
                resetSoft
            fi
        fi
    done

    if [ -z "$WVDIAL_CONFIG_SECTION" ]; then
        wvdial
    else
        wvdial "$WVDIAL_CONFIG_SECTION"
    fi

    if [ -f /tmp/ip-addr-ppp0 ]; then
        UNSUCCESSFUL_DIALIN_COUNT=0
        echo "Last dialin considered to have been successful because IPv4 address file for ppp0 exists: $(cat /tmp/ip-addr-ppp0)"
        rm -fv /tmp/ip-addr-ppp0
    else
        UNSUCCESSFUL_DIALIN_COUNT=$((UNSUCCESSFUL_DIALIN_COUNT + 1))
        echo "Last $UNSUCCESSFUL_DIALIN_COUNT dialin(s) considered to have been unsuccessful because IPv4 address file for ppp0 does not exist"
    fi

    if [ "$UNSUCCESSFUL_DIALIN_COUNT" -ge "$UNSUCCESSFUL_DIALIN_COUNT_LIMIT" ]; then
        UNSUCCESSFUL_DIALIN_COUNT=0
        echo "Last $UNSUCCESSFUL_DIALIN_COUNT_LIMIT dialins considered to have been unsuccessful"
        resetSoft
    fi

    handleStaleLock
    echo -e "\r" | microcom -t 2000 "/dev/$INTERFACE"
    echo -e "AT+CEER\r" | microcom -t 2000 "/dev/$INTERFACE"
done