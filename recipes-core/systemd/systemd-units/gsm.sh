#!/bin/bash

NAME=gsm
DESC="Initialization of gsm chip"

case $1 in
start)
    POWER_UP_SEQUENCE_DEFAULT="HL85xx_HL78xx-USB"
    POWER_UP_SEQUENCE="$POWER_UP_SEQUENCE_DEFAULT" # Works for the HL85xx and seems to work for the HL78xx in USB mode

    # For any device migrating from older firmware versions where neither cgmr nor
    # barebox-state are cached on the data partition, the device-tree fallback is
    # used at least for the first boot.
    # Since for every exiting device imx6ul implies HL85xx and imx6ull implies HL78xx
    # there are no issues to be expected.
    # In case HL85xx devices with imx6ull based SOM's would be produced in future,
    # the device-tree fallback would select the HL78xx startup procedure and the
    # HL85xx would not start. Before testing the HL85xx in production, e.g. the
    # "label" would have to be set e.g. to "401023" to select the default power-up
    # sequence.
    if [ -f /mnt/data/cgmr ]; then
        CGMR=$(cat /mnt/data/cgmr)
        echo "Using cached cgmr for type detection: $(cat /mnt/data/cgmr)"
        if [[ "$CGMR" =~ ^HL78 ]]; then
            POWER_UP_SEQUENCE="HL78xx"
        fi
    elif [ -f /mnt/data/barebox-state ]; then
        BAREBOX_STATE=$(cat /mnt/data/barebox-state)
        MANUFACTURER_ITEM="N/A"
        STROMER_LABEL="N/A"
        if [[ "$BAREBOX_STATE" =~ item=\"([^\"]+)\" ]]; then
            MANUFACTURER_ITEM="${BASH_REMATCH[1]}"
        fi
        if [[ "$BAREBOX_STATE" =~ label=\"([^\"]+)\" ]]; then
            STROMER_LABEL="${BASH_REMATCH[1]}"
        fi
        echo "Using cached item for type detection fallback: $MANUFACTURER_ITEM"
        if [[ "$MANUFACTURER_ITEM" =~ 0054726 ]]; then
            : # HL8548
        elif [[ "$MANUFACTURER_ITEM" =~ 3008744 ]]; then
            : # HL8548
        elif [[ "$MANUFACTURER_ITEM" =~ 3007514 ]]; then
            : # N/A
        elif [[ "$MANUFACTURER_ITEM" =~ 2118465 ]]; then
            POWER_UP_SEQUENCE="HL78xx"
        elif [[ "$MANUFACTURER_ITEM" =~ 2118517 ]]; then
            POWER_UP_SEQUENCE="HL78xx"
        elif [[ "$MANUFACTURER_ITEM" =~ 3029492 ]]; then
            : # HL8518
        elif [[ "$MANUFACTURER_ITEM" =~ 3029494 ]]; then
            : # HL8548-G
        elif [[ "$MANUFACTURER_ITEM" =~ 2118544 ]]; then
            POWER_UP_SEQUENCE="HL78xx"
        elif [[ "$MANUFACTURER_ITEM" =~ 2118610 ]]; then
            POWER_UP_SEQUENCE="HL78xx"
        else
            echo "Using cached label for type detection fallback: $STROMER_LABEL"
            if [[ "$STROMER_LABEL" =~ ^401023- ]]; then
                : # HL8548 (0054726 or 3008744)
            elif [[ "$STROMER_LABEL" =~ ^402173- ]]; then
                : # N/A
            elif [[ "$STROMER_LABEL" =~ ^403158- ]]; then
                POWER_UP_SEQUENCE="HL78xx"
            elif [[ "$STROMER_LABEL" =~ ^403730- ]]; then
                POWER_UP_SEQUENCE="HL78xx"
            elif [[ "$STROMER_LABEL" =~ ^403470- ]]; then
                : # HL8518
            elif [[ "$STROMER_LABEL" =~ ^403471- ]]; then
                : # HL8548-G
            else
                # For any newly produced device which does neither have "item" nor "label" set
                # yet, but barebox-state already exists with the default values "0000000"
                # resp. "000000", the device-tree fallback will be used.
                COMPATIBLE="$(tr -d '\0' < /proc/device-tree/compatible)"
                echo "Using device-tree for type detection fallback: $COMPATIBLE"
                if [[ "$COMPATIBLE" =~ imx6ull ]]; then
                    POWER_UP_SEQUENCE="HL78xx"
                fi
            fi
        fi
    else
        COMPATIBLE="$(tr -d '\0' < /proc/device-tree/compatible)"
        echo "Using device-tree for type detection fallback: $COMPATIBLE"
        if [[ "$COMPATIBLE" =~ imx6ull ]]; then
            POWER_UP_SEQUENCE="HL78xx"
        fi
    fi
    echo "POWER_UP_SEQUENCE: $POWER_UP_SEQUENCE"

    # GSM_ON_N (to gate of V13 on PWR_ON_N = ~GSM_ON_N)
    # GPIO5 IO05 => (5 - 1) * 32 + 5 = 133
    echo "133" > /sys/class/gpio/export
    echo "low" > /sys/class/gpio/gpio133/direction
    # GSM_RESET (to gate of V10 on RESET_IN_N = ~GSM_RESET)
    # GPIO5 IO00 => (5 - 1) * 32 = 128
    echo "128" > /sys/class/gpio/export
    echo "high" > /sys/class/gpio/gpio128/direction
    # 3V7_ON (to enable pin of U22)
    echo "497" > /sys/class/gpio/export
    echo "high" > /sys/class/gpio/gpio497/direction
    # Wait for 3V7 voltage to rise (U22 is configured via C162 to soft start over 16ms)
    sleep 0.2
    # Release GSM_RESET to start HL78xx (HL85xx should not care)
    echo "0" > /sys/class/gpio/gpio128/value
    if [ "$POWER_UP_SEQUENCE" == "$POWER_UP_SEQUENCE_DEFAULT" ]; then
        # Assert GSM_ON_N to start HL85xx (HL78xx in USB mode should not care)
        echo "1" > /sys/class/gpio/gpio133/value
    fi
    # Probe UART driver
    sleep 0.5
    modprobe imx6ul_mod_uart
;;

stop)
    # Remove UART driver
    rmmod imx6ul_mod_uart
    # Disable 3V7 voltage
    echo "0" > /sys/class/gpio/gpio497/value
;;

reload)
    # Pulse GSM reset (minimum assertion time is 10ms for HL85xx and 100us for HL78xx)
    echo "1" > /sys/class/gpio/gpio128/value
    sleep 0.1
    echo "0" > /sys/class/gpio/gpio128/value
;;

*)
    echo "Usage $0 {start|stop|reload}"
    exit
esac
