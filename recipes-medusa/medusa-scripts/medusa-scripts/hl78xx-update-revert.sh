#!/bin/bash

if lsusb -d 1519:0020; then
    echo "HL85xxx in USB mode detected"
    exit 0
elif lsusb -d 1199:c001; then
    echo "HL78xx in USB mode detected"
    echo "Run hl78xx-usbcomp-revert.sh first"
    exit 11
else
    CGMR=$(echo -e "AT+CGMR\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 /dev/ttymxc7 | grep ^HL78)
    if [[ $CGMR =~ ^HL78([0-9]+) ]]; then
        MODULE_VARIANT="${BASH_REMATCH[1]}"
        echo "HL78$MODULE_VARIANT detected"
        if cd /lib/firmware/sierra-wireless/HL78$MODULE_VARIANT.*; then
            if sha256sum -c SHA256SUMS; then
                echo "Checksums valid"
                cat /lib/firmware/sierra-wireless/HL78$MODULE_VARIANT.*/package_version | grep HL78$MODULE_VARIANT
                # Remark: Currently unclear why restarting the gsm service is necessary.
                echo "Restarting gsm service and waiting 10 seconds..."
                systemctl stop gsm
                sleep 5
                systemctl start gsm
                sleep 10
                echo "...done"
                echo ""
                echo "##############################"
                echo "!!!!!!!!!!BE CAREFUL!!!!!!!!!!"
                echo "##############################"
                echo "ABORTING THIS PROCEDURE (CTRL+C, POWER-CUT) WILL BRICK THE MODULE..."
                echo ""
                if sft -d -b 115200 -p /dev/ttymxc7 *; then
                    echo "Installation suceeded"
                    echo "...it is now safe to continue"
                    exit 0
                else
                    echo "Installation failed"
                    echo "...it is now safe to continue"
                    exit 11
                fi
            else
                echo "Checksums not valid"
                exit 11
            fi
        else
            echo "No applicable update folder found"
            exit 11
        fi
    else
        echo "No HL78xx in UART mode detected"
        echo "Run hl78xx-usbcomp.sh first"
        exit 11
    fi
fi
