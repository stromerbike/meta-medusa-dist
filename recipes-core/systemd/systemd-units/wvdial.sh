#!/bin/bash

source /etc/scripts/hlxxxx-common.sh

UNFINISHED_REGISTRATION_COUNT_LIMIT=99 # (99+1)x3s equals 300 seconds

UNRESPONSIVE_MODULE_COUNT_LIMIT=5 # (5+1)x(2000ms+3s) equals 30 seconds

UNSUCCESSFUL_DIALIN_COUNT_LIMIT=5
UNSUCCESSFUL_DIALIN_COUNT=0

INITIAL_LISTENING_PERIOD_DONE="no"

CURRENT_REVISION=""
CURRENT_REVISION_ZEROED=""

CGMR_READOUT_DONE="no"
OPERATOR_SELECTION_DONE="no"
SIM_SELECTION_DONE="no"
RAT_SELECTION_DONE="no"
PRL_SELECTION_DONE="no"

INTERFACE="ttyGSM0"
FULL_RESPONSE="/tmp/at_response"
NETWORK_REGISTRATION_READ_COMMAND="CREG"
WVDIAL_CONFIG_SECTION=""

if lsusb -d 1519:0020 >/dev/null; then
    echo "HL85xxx in USB mode detected"
    CGMR_READOUT_DONE="yes"
    OPERATOR_SELECTION_DONE="yes"
    SIM_SELECTION_DONE="yes"
    RAT_SELECTION_DONE="yes"
    PRL_SELECTION_DONE="yes"
elif lsusb -d 1199:c001 >/dev/null; then
    echo "HL78xx in USB mode detected"
    INTERFACE="ttyGSM1"
    NETWORK_REGISTRATION_READ_COMMAND="CREG?;+CEREG"
    WVDIAL_CONFIG_SECTION="hl78xx-usb"
fi

echo "INTERFACE: $INTERFACE"
echo "FULL_RESPONSE: $FULL_RESPONSE"
echo "NETWORK_REGISTRATION_READ_COMMAND: $NETWORK_REGISTRATION_READ_COMMAND"
echo "WVDIAL_CONFIG_SECTION: $WVDIAL_CONFIG_SECTION"

# Remark: The gsm-module service is stopped outside the udev rule too,
#         because the rule does not always seem to detect the remove event.
#         Furthermore, USB interface errors can sometimes be observed if those services
#         are still running when the module reset is being performed.
#         The wvdial service is not stopped in order to have a control process running
#         in case a reset (especially a hard reset) would not work.
function resetSoft() {
    while pgrep -fla hl78xx-update.sh
    do
        echo "Update (hl78xx-update.sh) is running. Waiting with soft reset."
        sleep 5
    done
    echo "Attempting to soft reset module..."
    systemctl stop gsm-module.service || true
    prepareComport
    if grep -m1 OK <(echo -e "AT+CFUN=1,1\r" | microcom -t 2000 "/dev/$INTERFACE"); then
        INITIAL_LISTENING_PERIOD_DONE="no"
        echo "...done"
        sleep 5
    else
        echo "...error"
    fi
    cleanupComport
}
function resetHard() {
    while pgrep -fla hl78xx-update.sh
    do
        echo "Update (hl78xx-update.sh) is running. Waiting with hard reset."
        sleep 5
    done
    echo "Attempting to hard reset module..."
    systemctl stop gsm-module.service || true
    if systemctl reload gsm; then
        INITIAL_LISTENING_PERIOD_DONE="no"
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
    IS_SOFT_RESET_REQUIRED="no"
    while true;
    do
        if [ -e "/dev/$INTERFACE" ]; then
            if [ "$INITIAL_LISTENING_PERIOD_DONE" == "no" ]; then
                prepareComport
                timeout -s KILL 10 microcom -t 2000 "/dev/$INTERFACE"
                cleanupComport
                INITIAL_LISTENING_PERIOD_DONE="yes"
            fi

            if [ "$CGMR_READOUT_DONE" == "no" ]; then
                echo "--> Querying revision identification..."
                prepareComport
                RESPONSE="$(grep -m1 "^HL78\|ERROR" <(echo -e "AT+CGMR\r" | timeout -s KILL 10 microcom -t 2000 "/dev/$INTERFACE" | tee $FULL_RESPONSE))"
                cleanupComport
                cat $FULL_RESPONSE
                if [[ $RESPONSE =~ ^HL78([0-9]+).(([0-9]+).([0-9]+).([0-9]+).([0-9]+)) ]]; then
                    MODULE_VARIANT="${BASH_REMATCH[1]}"
                    CURRENT_REVISION="${BASH_REMATCH[2]}"
                    # Some firmware versions have more than one digit per position in their version.
                    # For working nummerical comparisons, "0"'s are prepended for each position.
                    CURRENT_REVISION_ZEROED="$(printf "%03d%03d%03d%03d" ${BASH_REMATCH[3]} ${BASH_REMATCH[4]} ${BASH_REMATCH[5]} ${BASH_REMATCH[6]})"
                    echo "Current HL78$MODULE_VARIANT revision: $CURRENT_REVISION ($CURRENT_REVISION_ZEROED)"
                    CGMR_READOUT_DONE="yes"
                else
                    echo "...revision identification could not be read"
                fi
            fi

            if [ "$OPERATOR_SELECTION_DONE" == "no" ]; then
                echo "--> Querying operator selection..."
                prepareComport
                RESPONSE="$(grep -m1 "+KCARRIERCFG:\|ERROR" <(echo -e "AT+KCARRIERCFG?\r" | timeout -s KILL 10 microcom -t 2000 "/dev/$INTERFACE" | tee $FULL_RESPONSE))"
                cleanupComport
                cat $FULL_RESPONSE
                if [[ $RESPONSE =~ \+KCARRIERCFG:\ 0 ]]; then
                    echo "...operator selection is set correctly"
                    OPERATOR_SELECTION_DONE="yes"
                elif [[ $RESPONSE =~ (\+KCARRIERCFG:\ [^$'\r\n']+) ]]; then
                    echo "...operator selection has to be adjusted..."
                    prepareComport
                    RESPONSE="$(grep -m1 "OK\|ERROR" <(echo -e "AT+KCARRIERCFG=0\r" | timeout -s KILL 30 microcom -t 20000 "/dev/$INTERFACE" | tee $FULL_RESPONSE))"
                    cleanupComport
                    cat $FULL_RESPONSE
                    if [[ $RESPONSE =~ OK ]]; then
                        echo "...done"
                        OPERATOR_SELECTION_DONE="yes"
                        IS_SOFT_RESET_REQUIRED="yes"
                    else
                        echo "...error"
                    fi
                else
                    echo "...operator selection could not be read"
                fi
            fi
            if [ "$SIM_SELECTION_DONE" == "no" ]; then
                echo "--> Querying SIM selection..."
                prepareComport
                RESPONSE="$(grep -m1 "+KSIMSEL:\|ERROR" <(echo -e "AT+KSIMSEL?\r" | timeout -s KILL 10 microcom -t 2000 "/dev/$INTERFACE" | tee $FULL_RESPONSE))"
                cleanupComport
                cat $FULL_RESPONSE
                if [[ $RESPONSE =~ \+KSIMSEL:\ 0 ]]; then
                    echo "...SIM selection is set correctly"
                    SIM_SELECTION_DONE="yes"
                elif [[ $RESPONSE =~ (\+KSIMSEL:\ [^$'\r\n']+) ]]; then
                    echo "...SIM selection has to be adjusted..."
                    prepareComport
                    RESPONSE="$(grep -m1 "OK\|ERROR" <(echo -e "AT+KSIMSEL=0\r" | timeout -s KILL 30 microcom -t 20000 "/dev/$INTERFACE" | tee $FULL_RESPONSE))"
                    cleanupComport
                    cat $FULL_RESPONSE
                    if [[ $RESPONSE =~ OK ]]; then
                        echo "...done"
                        SIM_SELECTION_DONE="yes"
                        IS_SOFT_RESET_REQUIRED="yes"
                    else
                        echo "...error"
                    fi
                else
                    echo "...SIM selection could not be read"
                fi
            fi

            if [ "$CGMR_READOUT_DONE" == "yes" ] && [ "$RAT_SELECTION_DONE" == "no" ]; then
                echo "--> Querying RAT selection..."
                prepareComport
                RESPONSE="$(grep -m1 "+KSRAT:\|ERROR" <(echo -e "AT+KSRAT?\r" | timeout -s KILL 10 microcom -t 2000 "/dev/$INTERFACE" | tee $FULL_RESPONSE))"
                cleanupComport
                cat $FULL_RESPONSE
                # Legacy command AT+KSRAT
                # If legacy operation compatibility is not needed, AT+KSRAT should be kept at its default setting (0).
                # 0: CAT-M
                # 1: NB-IoT
                # 2: GSM
                if [[ $RESPONSE =~ \+KSRAT:\ 0 ]]; then
                    echo "...RAT selection is set correctly"
                    RAT_SELECTION_DONE="yes"
                elif [[ $RESPONSE =~ (\+KSRAT:\ [^$'\r\n']+) ]]; then
                    echo "...RAT selection has to be adjusted..."
                    prepareComport
                    RESPONSE="$(grep -m1 "OK\|ERROR" <(echo -e "AT+KSRAT=0\r" | timeout -s KILL 10 microcom -t 2000 "/dev/$INTERFACE" | tee $FULL_RESPONSE))"
                    cleanupComport
                    cat $FULL_RESPONSE
                    if [[ $RESPONSE =~ OK ]]; then
                        echo "...done"
                        RAT_SELECTION_DONE="yes"
                        if [ $((10#$CURRENT_REVISION_ZEROED)) -lt 4005004000 ]; then
                            echo "A soft reset will be carried out."
                            IS_SOFT_RESET_REQUIRED="yes" # HL78xx fimware versions before 4.5.4.0 require a reset to take effect
                        fi
                    else
                        echo "...error"
                    fi
                else
                    echo "...RAT selection could not be read"
                fi
            fi
            if [ "$CGMR_READOUT_DONE" == "yes" ] && [ "$PRL_SELECTION_DONE" == "no" ]; then
                if [ $((10#$CURRENT_REVISION_ZEROED)) -ge 4006009004 ]; then # 4.6.9.4 and newer
                    echo "--> AT+KSELACQ supported. Querying PRL selection..."
                    prepareComport
                    RESPONSE="$(grep -m1 "+KSELACQ:\|ERROR" <(echo -e "AT+KSELACQ?\r" | timeout -s KILL 10 microcom -t 2000 "/dev/$INTERFACE" | tee $FULL_RESPONSE))"
                    cleanupComport
                    cat $FULL_RESPONSE
                    # New command AT+KSELACQ for HL78xx firmware versions 4.5.4.0+ and an empty list as PRL default setting (0).
                    # 1: CAT-M
                    # 2: NB-IoT
                    # 3: GSM
                    if [[ $RESPONSE =~ \+KSELACQ:\ 1,3 ]]; then
                        echo "...PRL selection is set correctly"
                        PRL_SELECTION_DONE="yes"
                    elif [[ $RESPONSE =~ (\+KSELACQ:\ [^$'\r\n']+) ]]; then
                        echo "...PRL selection is supported but has to be adjusted..."
                        prepareComport
                        RESPONSE="$(grep -m1 "OK\|ERROR" <(echo -e "AT+KSELACQ=0,1,3\r" | timeout -s KILL 10 microcom -t 2000 "/dev/$INTERFACE" | tee $FULL_RESPONSE))"
                        cleanupComport
                        cat $FULL_RESPONSE
                        if [[ $RESPONSE =~ OK ]]; then
                            echo "...done"
                            PRL_SELECTION_DONE="yes"
                            IS_SOFT_RESET_REQUIRED="yes"
                        else
                            echo "...error"
                        fi
                    fi
                elif [ $((10#$CURRENT_REVISION_ZEROED)) -ge 4005004000 ]; then # 4.5.4.0 and newer
                    # The HL78xx firmware version 4.5.4.0 would support the command AT+KSELACQ.
                    # It is not handled because 4.5.4.0 is only an intermediate step during the update procedure from 4.4.14.0 to 4.6.9.4.
                    # Furthermore, the soft reset after a value change of AT+KSELACQ would interfere with the update procedure.
                    echo "AT+KSELACQ supported but not handled."
                    PRL_SELECTION_DONE="yes"
                else
                    echo "AT+KSELACQ not supported."
                    PRL_SELECTION_DONE="yes"
                fi
            fi

            if [ "$OPERATOR_SELECTION_DONE" == "yes" ] && [ "$SIM_SELECTION_DONE" == "yes" ] && [ "$RAT_SELECTION_DONE" == "yes" ] && [ "$PRL_SELECTION_DONE" == "yes" ]; then
                if [ "$IS_SOFT_RESET_REQUIRED" == "yes" ]; then
                    IS_SOFT_RESET_REQUIRED="no"
                    UNFINISHED_REGISTRATION_COUNT=0
                    UNRESPONSIVE_MODULE_COUNT=0
                    resetSoft
                else
                    prepareComport
                    RESPONSE="$(grep -m1 "+CREG:\|+CEREG:" <(echo -e "AT+$NETWORK_REGISTRATION_READ_COMMAND?\r" | timeout -s KILL 10 microcom -t 2000 "/dev/$INTERFACE" | tee $FULL_RESPONSE))"
                    cleanupComport
                    # 1: Registered, home network
                    # 5: Registered, roaming
                    if [[ $RESPONSE =~ \+CE?REG:\ (0|1|2|3|4|5),(1|5) ]]; then
                        UNRESPONSIVE_MODULE_COUNT=0
                        echo "...registration done:"
                        cat $FULL_RESPONSE
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
                        cat $FULL_RESPONSE
                        if [ "$UNRESPONSIVE_MODULE_COUNT" -lt "$UNRESPONSIVE_MODULE_COUNT_LIMIT" ]; then
                            UNRESPONSIVE_MODULE_COUNT=$((UNRESPONSIVE_MODULE_COUNT + 1))
                            echo "Module unresponsive for $UNRESPONSIVE_MODULE_COUNT time(s in a row)"
                        else
                            UNFINISHED_REGISTRATION_COUNT=0
                            UNRESPONSIVE_MODULE_COUNT=0
                            resetHard
                        fi
                    fi
                    sleep 3
                fi
            fi
        else
            echo "Interface /dev/$INTERFACE does not exist"
            sleep 1
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

    prepareComport
    echo -e "\r" | timeout -s KILL 10 microcom -t 2000 "/dev/$INTERFACE"
    cleanupComport
    prepareComport
    echo -e "AT+CEER\r" | timeout -s KILL 10 microcom -t 2000 "/dev/$INTERFACE"
    cleanupComport
done
