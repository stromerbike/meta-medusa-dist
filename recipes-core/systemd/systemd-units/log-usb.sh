#!/bin/bash

led1_blue ()
{
    echo "255" 2> /dev/null > /sys/class/leds/rgb1_blue/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb1_green/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb1_red/brightness
}

led1_off ()
{
    echo "0" 2> /dev/null > /sys/class/leds/rgb1_blue/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb1_green/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb1_red/brightness
}

led2_blue ()
{
    echo "255" 2> /dev/null > /sys/class/leds/rgb2_blue/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_green/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_red/brightness
}

led2_red ()
{
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_blue/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_green/brightness
    echo "255" 2> /dev/null > /sys/class/leds/rgb2_red/brightness
}

led2_off ()
{
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_blue/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_green/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_red/brightness
}

unmount_usb ()
{
    echo "Syncing..."
    if sync; then
        echo "...done"
    fi
    if df -T | grep "/mnt/usb" | grep "fuseblk"; then
        echo "Unmounting (-f) usb..."
        if umount -f /mnt/usb; then
            echo "...done"
        fi
    else
        echo "Unmounting usb..."
        if umount /mnt/usb; then
            echo "...done"
        fi
    fi
    led1_off
    led2_off
    exit 0
}

if [ -d "/mnt/usb/log" ]; then
    led1_blue
    LOGFILE="/mnt/usb/log/$(hostname)_$(date --utc +"%Y-%m-%d-%H%M%S")_$(cat /etc/medusa-version)"
    echo "Writing short log to $LOGFILE-short.zip..."
    led2_blue
    if journalctl -a -o short-precise --no-hostname --no-pager | gzip > $LOGFILE-short.zip; then
        echo "...done ($(stat -c%s $LOGFILE-short.zip) bytes written)"
        echo "Writing json log to $LOGFILE-json.zip..."
        if journalctl -a -o json --no-pager --output-fields=MESSAGE,PRIORITY,_PID,SYSLOG_IDENTIFIER,_SYSTEMD_UNIT | gzip > $LOGFILE-json.zip; then
            echo "...done ($(stat -c%s $LOGFILE-json.zip) bytes written)"
            for i in btmon candump
            do
                if [ -d "/mnt/data/$i" ] && [ ! -z "$(ls -A /mnt/data/$i)" ]; then
                    echo "Writing $i log to $LOGFILE-$i.zip..."
                    if zip -j $LOGFILE-$i.zip /mnt/data/$i/*; then
                        echo "...done ($(stat -c%s $LOGFILE-$i.zip) bytes written)"
                        echo "Removing $i files..."
                        if rm -rf /mnt/data/$i/*; then
                            echo "...done"
                        else
                            echo "<4>...WARNING could not remove $i files"
                        fi
                    else
                        echo "<3>...ERROR ($(stat -c%s $LOGFILE-$i.zip) bytes written)"
                        unmount_usb
                        led2_red
                        exit 1
                    fi
                fi
            done
            unmount_usb
        else
            echo "<3>...ERROR ($(stat -c%s $LOGFILE-json.zip) bytes written)"
            unmount_usb
            led2_red
            exit 1
        fi
    else
        echo "<3>...ERROR ($(stat -c%s $LOGFILE-short.zip) bytes written)"
        led2_red
        exit 1
    fi
fi
