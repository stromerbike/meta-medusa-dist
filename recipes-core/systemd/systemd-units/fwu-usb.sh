#!/bin/bash

OPTION_PURGEDATA_IGNORE="no"

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

led2_green ()
{
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_blue/brightness
    echo "255" 2> /dev/null > /sys/class/leds/rgb2_green/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_red/brightness
}

led2_red ()
{
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_blue/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_green/brightness
    echo "255" 2> /dev/null > /sys/class/leds/rgb2_red/brightness
}

led2_white ()
{
    echo "255" 2> /dev/null > /sys/class/leds/rgb2_blue/brightness
    echo "255" 2> /dev/null > /sys/class/leds/rgb2_green/brightness
    echo "255" 2> /dev/null > /sys/class/leds/rgb2_red/brightness
}

led2_off ()
{
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_blue/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_green/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_red/brightness
}

display_done ()
{
    fbi --noverbose -T 3 /etc/images/done.png
    led2_green
}

display_error ()
{
    echo "...ERROR"
    led2_red
    fbi --noverbose -T 3 /etc/images/error.png
}

enable_writeaccess ()
{
    if [ -f /mnt/sda/autoupdate-settings/writeaccess* ] || [ -f /mnt/sda1/autoupdate-settings/writeaccess* ]; then
        echo "Modifying fstab for write access"
        sed -i -e '/^[#[:space:]]*\/dev\/root/{s/[[:space:]]ro/ defaults/;s/\([[:space:]]*[[:digit:]]\)\([[:space:]]*\)[[:digit:]]$/\1\20/}' /mnt/rfs_inactive/etc/fstab
    else
        echo "Keeping fstab untouched"
    fi
}

purge_data ()
{
    if [ "$OPTION_PURGEDATA_IGNORE" == "no" ]; then
        if [ -f /mnt/sda/autoupdate-settings/purgedata* ] || [ -f /mnt/sda1/autoupdate-settings/purgedata* ]; then
            echo "Purging data partition"
            rm -rf /mnt/data/*
        else
            echo "Keeping data partition"
        fi
    else
        echo "Ignoring data partition"
    fi
}

umount_sda ()
{
    if [ -d "/mnt/sda/autoupdate" ]; then
        echo "Unmounting sda..."
        if umount /mnt/sda; then
            echo "...done"
        else
            echo "...ERROR"
        fi
    else
        echo "Unmounting sda1..."
        if umount /mnt/sda1; then
            echo "...done"
        else
            echo "...ERROR"
        fi
    fi
}

await_shutdown ()
{
    echo "Waiting for touch event..."
    while evtest --query /dev/input/event1 EV_KEY BTN_TOUCH; do
        sleep 0.1
    done
    echo "...done"
    fbi --noverbose -T 3 /etc/images/logo.png
    echo "Shutting down..."
    shutdown now
}

part0_active ()
{
    echo "Setting partition 0 as active one..."
    if barebox-state -s partition=0; then
        echo "...done"
        purge_data
        umount_sda
        display_done
        await_shutdown
    else
        display_error
    fi
}

part1_active ()
{
    echo "Setting partition 1 as active one..."
    if barebox-state -s partition=1; then
        echo "...done"
        purge_data
        umount_sda
        display_done
        await_shutdown
    else
        display_error
    fi
}

# To handle cases where RecordCommander gets stuck a SIGKILL is sent after 5s using timeout.
# Determine if timeout is provided by busybox or coreutils beforehand since they have a different syntax.
TIMEOUT_CMD=""
if ls -l `which timeout` | grep busybox > /dev/null; then
    TIMEOUT_CMD="timeout -s KILL -t 5"
else
    TIMEOUT_CMD="timeout -s KILL 5"
fi

COUNTER=0
while [ $COUNTER -lt 5 ];
do
    let COUNTER=COUNTER+1
    if [ -d "/mnt/sda1/autoupdate" ]; then
        firstFile=""
        firstFile="/mnt/sda1/autoupdate/$(ls /mnt/sda1/autoupdate | head -n 1)"
        if [[ $firstFile =~ .*medusa-image-[a-zA-Z0-9.-]+.rootfs.(tar|tar.gz|tar.xz)$ ]]; then
            echo "Firmware tarball $firstFile found"
            if [[ $firstFile =~ .*$(cat /etc/medusa-version).rootfs.(tar|tar.gz|tar.xz)$ ]]; then
                echo "Nothing to up- or downgrade"
                exit 0
            else
                if [[ "$($TIMEOUT_CMD /usr/bin/medusa/RecordCommander/RecordCommander /usr/bin/medusa/TargetIpcConfiguration.json "get 8001")" =~ true ]]; then
                    echo "locked is true: purgedata will be ignored!"
                    OPTION_PURGEDATA_IGNORE="yes"
                else
                    echo "locked is false"
                fi
                if [[ "$($TIMEOUT_CMD /usr/bin/medusa/RecordCommander/RecordCommander /usr/bin/medusa/TargetIpcConfiguration.json "get 8002")" =~ true ]]; then
                    echo "theft is true: purgedata will be ignored!"
                    OPTION_PURGEDATA_IGNORE="yes"
                else
                    echo "theft is false"
                fi
                echo "Stopping DataServer based applications..."
                systemctl stop medusa-DataServer || true
                echo "...done"
                echo "100" 2> /dev/null > /sys/class/backlight/background/brightness
                echo "Verifying signature..."
                led1_blue
                fbi --noverbose -T 3 /etc/images/busy.png
                if gpgv --keyring /etc/gnupg/pubring.gpg "$firstFile.sig" "$firstFile"; then
                    if mountpoint -q /mnt/rfs_inactive; then
                        echo "...done"
                        led2_blue
                        echo "Extracting firmware..."
                        rm -rf /tmp/rfs_inactive || true
                        mkdir /tmp/rfs_inactive
                        if tar -xf $firstFile -C /tmp/rfs_inactive --warning=no-timestamp; then
                            echo "...done"
                            echo "Rsyncing to inactive rfs partition..."
                            if rsync -a -c --delete /tmp/rfs_inactive/ /mnt/rfs_inactive/; then
                                echo "...done"
                                enable_writeaccess
                                echo "Syncing..."
                                if sync; then
                                    echo "...done"
                                    echo "Swapping active partition..."
                                    if df | grep 'ubi0:part0'; then
                                        part1_active
                                    elif df | grep 'ubi0:part1'; then
                                        part0_active
                                    else
                                        display_error
                                        COUNTER=5
                                    fi
                                else
                                    display_error
                                    COUNTER=5
                                fi
                            else
                                display_error
                                COUNTER=5
                            fi
                        else
                            display_error
                            COUNTER=5
                        fi
                    else
                        display_error
                        COUNTER=5
                    fi
                else
                    display_error
                    COUNTER=5
                fi
            fi
        else
            echo "autoupdate folder does not contain the required file"
        fi
    else
        echo "/mnt/sda1/autoupdate does not exist (yet)"
    fi
    sleep 1
done
