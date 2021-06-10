#!/bin/bash

UNFINISHED_REGISTRATION_COUNT_LIMIT=179 # (179+1)x5000ms equals 900 seconds

UNRESPONSIVE_MODULE_COUNT_LIMIT=5 # (5+1)x5000ms equals 30 seconds

UNSUCCESSFUL_DIALIN_COUNT_LIMIT=5
UNSUCCESSFUL_DIALIN_COUNT=0

NETWORK_REGISTRATION_EXEC_COMMAND_SUCCESSFUL="no"

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

# Remark: The gsm-module and interceptty services are stopped outside the udev rule too,
#         because the rule does not always seem to detect the remove event.
#         Furthermore, USB interface errors can sometimes be observed if those services
#         are still running when the module reset is being performed.
#         The wvdial service is not stopped in order to have a control process running
#         in case a reset (especially a hard reset) would not work.
function resetSoft() {
    echo "Attempting to soft reset module..."
    systemctl stop gsm-module.service || true
    systemctl stop interceptty@* || true
    handleStaleLock
    if echo -e "AT+CFUN=1,1\r" | microcom -t 500 "/dev/$INTERFACE" | grep -m1 OK; then
        NETWORK_REGISTRATION_EXEC_COMMAND_SUCCESSFUL="no"
        echo "...done"
        sleep 5
    else
        echo "...error"
    fi
}
function resetHard() {
    echo "Attempting to hard reset module..."
    systemctl stop gsm-module.service || true
    systemctl stop interceptty@* || true
    if systemctl reload gsm; then
        NETWORK_REGISTRATION_EXEC_COMMAND_SUCCESSFUL="no"
        echo "...done"
        sleep 5
    else
        echo "...error"
    fi
}

while true;
do
    echo "Waiting for network registration to home network or roaming..."
    UNFINISHED_REGISTRATION_COUNT=0
    UNRESPONSIVE_MODULE_COUNT=0
    while true;
    do
        if [ -e "/dev/$INTERFACE" ]; then
            if [ "$NETWORK_REGISTRATION_EXEC_COMMAND_SUCCESSFUL" == "no" ]; then
                echo "Enabling network registration unsolicited result code..."
                handleStaleLock
                if echo -e "AT+$NETWORK_REGISTRATION_EXEC_COMMAND\r" | microcom -t 2000 "/dev/$INTERFACE" | grep -m1 OK; then
                    NETWORK_REGISTRATION_EXEC_COMMAND_SUCCESSFUL="yes"
                    echo "...done"
                else
                    echo "...error"
                fi
            fi

            handleStaleLock
            RESPONSE="$(echo -e "AT+$NETWORK_REGISTRATION_READ_COMMAND?\r" | microcom -t 5000 "/dev/$INTERFACE")"
            if [[ $RESPONSE =~ \+CE?REG:\ (0|1|2|3|4|5),(1|5) ]]; then
                UNRESPONSIVE_MODULE_COUNT=0
                echo "...registration done:"
                echo "$RESPONSE"
                break
            elif [[ "$RESPONSE" =~ (\+CE?REG:\ [^$'\r\n']+) ]]; then
                UNRESPONSIVE_MODULE_COUNT=0
                echo "${BASH_REMATCH[1]}"
                if [ "$UNFINISHED_REGISTRATION_COUNT" -lt "$UNFINISHED_REGISTRATION_COUNT_LIMIT" ]; then
                    UNFINISHED_REGISTRATION_COUNT=$((UNFINISHED_REGISTRATION_COUNT + 1))
                    echo "Registration unfinished for $UNFINISHED_REGISTRATION_COUNT time(s in a row)"
                else
                    UNFINISHED_REGISTRATION_COUNT=0
                    UNRESPONSIVE_MODULE_COUNT=0
                    resetSoft
                fi
            else
                echo "$RESPONSE"
                if [ "$UNRESPONSIVE_MODULE_COUNT" -lt "$UNRESPONSIVE_MODULE_COUNT_LIMIT" ]; then
                    UNRESPONSIVE_MODULE_COUNT=$((UNRESPONSIVE_MODULE_COUNT + 1))
                    echo "Module unresponsive for $UNRESPONSIVE_MODULE_COUNT time(s in a row)"
                else
                    UNFINISHED_REGISTRATION_COUNT=0
                    UNRESPONSIVE_MODULE_COUNT=0
                    resetHard
                fi
            fi
        else
            echo "Interface /dev/$INTERFACE does not exist"
            sleep 5
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
