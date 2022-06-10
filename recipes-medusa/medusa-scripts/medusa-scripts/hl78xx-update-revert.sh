#!/bin/bash

source /etc/scripts/hlxxxx-common.sh

INTERFACE="ttymxc7"

if lsusb -d 1519:0020; then
    echo "HL85xxx in USB mode detected"
    exit 0
elif lsusb -d 1199:c001; then
    echo "HL78xx in USB mode detected"
    # Remark:
    # The following command seems to work when the module is in USB mode:
    # sft -d -p /dev/ttyGSM1 -g /dev/ttyGSMBL *
    # Since unstable transmissions were observed which led to modules only
    # recoverable via debug UART, sft in USB mode is not supported by this script.
    echo "Run hl78xx-usbcomp-revert.sh first"
    exit 11
else
    prepareComport
    CGMR=$(echo -e "AT+CGMR\r" | timeout -s KILL 2 picocom -qr -b 115200 -f h -x 1000 "/dev/$INTERFACE" | grep ^HL78)
    cleanupComport
    if [[ $CGMR =~ ^HL78([0-9]+) ]]; then
        MODULE_VARIANT="${BASH_REMATCH[1]}"
        echo "HL78$MODULE_VARIANT detected"
        if cd /lib/firmware/sierra-wireless/HL78$MODULE_VARIANT.*; then
            if sha256sum -c SHA256SUMS; then
                echo "Checksums valid"
                cat /lib/firmware/sierra-wireless/HL78$MODULE_VARIANT.*/package_version | grep HL78$MODULE_VARIANT
                # Remark: Currently unclear why restarting the gsm service is necessary.    
                #         Wait some reconds afterwards to keep sft from trying other baudrates already.
                echo "Restarting gsm service..."
                systemctl restart gsm
                sleep 5
                echo "...done"
                echo ""
                echo "##############################"
                echo "!!!!!!!!!!BE CAREFUL!!!!!!!!!!"
                echo "##############################"
                echo "ABORTING THIS PROCEDURE (CTRL+C, POWER-CUT) WILL BRICK THE MODULE..."
                echo ""
                # Remark: Recovery of a bricked module is possible by connecting the debug UART
                #         via their testpoints and running sft on a PC via e.g. ttyUSBx.
                prepareComport
                if sft -d -b 115200 -p "/dev/$INTERFACE" *; then
                    cleanupComport
                    echo "Installation suceeded"
                    echo "...it is now safe to continue"
                    exit 0
                else
                    cleanupComport
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
