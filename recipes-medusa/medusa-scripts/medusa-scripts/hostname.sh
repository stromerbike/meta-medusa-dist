#!/bin/bash

if [ -e /dev/gsmtty4 ]; then
    CIMI="$(echo -e "AT+CIMI\r" | microcom -t 2000 /dev/gsmtty4)"
elif [ -e /dev/ttyGSM5 ]; then
    GARBAGE="$(echo -e "AT+CIMI\r" | microcom -t 2000 /dev/ttyGSM5)"
    CIMI="$(echo -e "AT+CIMI\r" | microcom -t 2000 /dev/ttyGSM5)"
elif [ -f /tmp/imsi ]; then
    CIMI="$(cat /tmp/imsi)"
fi

HOSTNAME="UNKNOWN"
if [[ $CIMI =~ ([0-9]+) ]]; then
    HOSTNAME="${BASH_REMATCH[1]}"
else
    OUTPUT=$(hcitool -i hci0 cmd 0x04 0x0009 2>/dev/null)
    if [[ $OUTPUT =~ 09\ 10\ 00\ ([0-9A-F]+)\ ([0-9A-F]+)\ ([0-9A-F]+)\ ([0-9A-F]+)\ ([0-9A-F]+)\ ([0-9A-F]+)\  ]]; then
        HOSTNAME="${BASH_REMATCH[6]}${BASH_REMATCH[5]}${BASH_REMATCH[4]}${BASH_REMATCH[3]}${BASH_REMATCH[2]}${BASH_REMATCH[1]}"
    else
        STDOUT="$(barebox-state -g label 2>/dev/null)"
        if [ $? -eq 0 ]; then
            HOSTNAME="$STDOUT"
        fi
    fi
fi

echo "$HOSTNAME"
