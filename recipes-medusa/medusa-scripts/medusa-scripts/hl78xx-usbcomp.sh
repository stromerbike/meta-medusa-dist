#!/bin/bash

if lsusb -d 1519:0020; then
    echo "HL85xxx in USB mode detected"
elif lsusb -d 1199:c001; then
    echo "HL78xx in USB mode detected"
    KUSBCOMP=$(echo -e "AT+KUSBCOMP?\r" | microcom -t 1000 /dev/ttyACM0 | grep +KUSBCOMP:)
    if [[ $KUSBCOMP =~ \+KUSBCOMP:\ 1,1,2,3 ]]; then
        echo "USB mode with desired interface assignments: $KUSBCOMP"
    else
        echo "USB mode with undesired interface assignments: $KUSBCOMP"
        echo -e "AT+KUSBCOMP=1,1,2,3\r" | microcom -t 1000 /dev/ttyACM0 >/dev/null
        KUSBCOMP=$(echo -e "AT+KUSBCOMP?\r" | microcom -t 1000 /dev/ttyACM0 | grep +KUSBCOMP:)
        if [[ $KUSBCOMP =~ \+KUSBCOMP:\ 1,1,2,3 ]]; then
            echo "Interface assigments adjusted to $KUSBCOMP"
            echo "Restarting gsm service"
            systemctl reload gsm
        else
            echo "Interface assignments not adjusted correctly ($KUSBCOMP)"
        fi
    fi
else
    CGMR=$(echo -e "AT+CGMR\r" | picocom -qr -b 115200 -f h -x 1000 /dev/ttymxc7 | grep ^HL78)
    if [[ $CGMR =~ HL78 ]]; then
        echo "HL78xx in UART mode detected issuing AT+KUSBCOMP=1,1,2,3 and restarting gsm service"
        if echo -e "AT+KUSBCOMP=1,1,2,3\r" | picocom -qr -b 115200 -f h -x 1000 /dev/ttymxc7 | grep AT+KUSBCOMP=1,1,2,3; then
            echo "USB mode activated. Restarting gsm service."
            systemctl reload gsm
        else
            echo "USB mode not activated"
        fi
    else
        echo "no HL78xx in UART mode detected"
    fi
fi

