#!/bin/bash

export_log ()
{
    echo "Exporting log..."
    systemctl start log-usb || true
    echo "...done"
}

COUNTER=0
while [ $COUNTER -lt 5 ];
do
    let COUNTER=COUNTER+1
    if [ -d "/mnt/usb/autoupdate" ]; then
        firstTarXz="/mnt/usb/autoupdate/$(ls /mnt/usb/autoupdate | grep .tar.xz | head -n 1)"
        if [[ $firstTarXz =~ .*medusa-image-[a-zA-Z0-9.-]+.rootfs.tar.xz$ ]]; then
            echo "Firmware tarball $firstTarXz found"
            if [[ ${firstTarXz/-purgedata/} =~ .*$(cat /etc/medusa-version).rootfs.tar.xz$ ]]; then
                echo "Nothing to up- or downgrade"
                export_log
                exit 0
            else
                echo "Starting fwu-usb-run now..."
                systemctl start fwu-usb-run
                echo "...done"
                exit 0
            fi
        else
            echo "autoupdate folder does not contain the required file"
        fi
    else
        echo "/mnt/usb/autoupdate does not exist (yet)"
    fi
    sleep 1
done

export_log
