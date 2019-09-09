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

led2_off ()
{
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_blue/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_green/brightness
    echo "0" 2> /dev/null > /sys/class/leds/rgb2_red/brightness
}

display_done ()
{
    echo "" | fbv --noinfo /etc/images/done.png
    led2_green
}

display_error ()
{
    echo "...ERROR"
    led2_red
    echo "" | fbv --noinfo /etc/images/error.png
}

enable_writeaccess ()
{
    if [ -f /mnt/usb/autoupdate-settings/writeaccess ]; then
        echo "Modifying fstab for write access"
        sed -i -e '/^[#[:space:]]*\/dev\/root/{s/[[:space:]]ro/ defaults/;s/\([[:space:]]*[[:digit:]]\)\([[:space:]]*\)[[:digit:]]$/\1\20/}' /mnt/rfs_inactive/etc/fstab
    else
        echo "Keeping fstab untouched"
    fi
}

check_purge_data_ignore ()
{
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
}

purge_data ()
{
    if [ -f /mnt/usb/autoupdate-settings/purgedata ]; then
        if [ "$OPTION_PURGEDATA_IGNORE" == "no" ]; then
            echo "Starting DataServer..."
            systemctl start medusa-DataServer || true
            echo "...done"
            echo "Rechecking if purgedata shall be ignored..."
            check_purge_data_ignore # recheck a second time in case fwu-usb has been aborted prematurely before (e.g. by pulling usb)
            echo "...done"
            if [ "$OPTION_PURGEDATA_IGNORE" == "no" ]; then
                echo "Stopping DataServer application..."
                systemctl stop medusa-DataServer || true
                echo "...done"
                echo "Purging data partition"
                rm -rf /mnt/data/*
                echo "...done"
            else
                echo "Keeping data partition"
            fi
        else
            echo "Keeping data partition"
        fi
    else
        echo "Ignoring data partition"
    fi
}

umount_usb ()
{
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
}

await_shutdown ()
{
    echo "Waiting for touch event..."
    while evtest --query /dev/input/event1 EV_KEY BTN_TOUCH; do
        sleep 0.1
    done
    echo "...done"
    echo "" | fbv --noinfo /etc/images/logo.png
    echo "Shutting down now..."
    shutdown now
}

part0_active ()
{
    echo "Setting partition 0 as active one..."
    if barebox-state -s partition=0; then
        echo "...done"
        purge_data
        export_log
        umount_usb
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
        export_log
        umount_usb
        display_done
        await_shutdown
    else
        display_error
    fi
}

export_log ()
{
    echo "Exporting log..."
    systemctl start log-usb || true
    echo "...done"
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
    if [ -d "/mnt/usb/autoupdate" ]; then
        firstFile=""
        firstFile="/mnt/usb/autoupdate/$(ls /mnt/usb/autoupdate | head -n 1)"
        if [[ $firstFile =~ .*medusa-image-[a-zA-Z0-9.-]+.rootfs.tar.xz$ ]]; then
            echo "Firmware tarball $firstFile found"
            if [[ $firstFile =~ .*$(cat /etc/medusa-version).rootfs.tar.xz$ ]]; then
                echo "Nothing to up- or downgrade"
                export_log
                exit 0
            else
                echo "Checking if purgedata shall be ignored..."
                check_purge_data_ignore
                echo "...done"
                echo "Stopping DataServer application..." # also stops DataServer based applications
                systemctl stop medusa-DataServer || true
                echo "...done"
                echo "100" 2> /dev/null > /sys/class/backlight/background/brightness
                echo "Verifying signature..."
                led1_blue
                TERM=linux clear > /dev/tty1 < /dev/tty1
                echo 0 > /sys/class/graphics/fbcon/rotate_all
                /usr/sbin/setfont /usr/share/consolefonts/cp850-8x16.psfu.gz -C /dev/tty1
                TERM=linux setterm -blank 0 -powerdown 0 -powersave off > /dev/tty1 < /dev/tty1
                echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" > /dev/tty1
                echo "" | fbv --noinfo /etc/images/busy.png
                echo -n "${firstFile: -44:-14}" > /dev/tty1
                if pv -F "Verifying:  %p" "$firstFile" 2> /dev/tty1 | gpgv --keyring /etc/gnupg/pubring.gpg "$firstFile.sig" -; then
                    if mountpoint -q /mnt/rfs_inactive; then
                        echo "...done"
                        led2_blue
                        echo "Cleaning up inactive partition..."
                        if rm -rf /mnt/rfs_inactive/*; then
                            echo "...done"
                            echo "Extracting firmware..."
                            if pv -F "Extracting: %p" "$firstFile" 2> /dev/tty1 | tar -xJ -C /mnt/rfs_inactive --warning=no-timestamp; then
                                echo "...done"
                                enable_writeaccess
                                echo "Syncing..."
                                echo -ne "Syncing...\r" > /dev/tty1
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
        echo "/mnt/usb/autoupdate does not exist (yet)"
    fi
    sleep 1
done

export_log
