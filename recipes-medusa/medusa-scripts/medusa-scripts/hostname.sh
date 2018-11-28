#!/bin/bash

if [ -e /dev/ttyACM4 ]; then
    GARBAGE="$(echo -e "AT+CIMI\r" | microcom -t 2000 /dev/ttyACM4)"
    CIMI="$(echo -e "AT+CIMI\r" | microcom -t 2000 /dev/ttyACM4)"
fi

HOSTNAME="UNKNOWN"
if [[ $CIMI =~ ([0-9]+) ]]; then
    HOSTNAME="${BASH_REMATCH[1]}"
else
    STDOUT="$(barebox-state -g label 2>/dev/null)"
    if [ $? -eq 0 ]; then
        HOSTNAME="$STDOUT"
    fi
fi

echo "$HOSTNAME"
