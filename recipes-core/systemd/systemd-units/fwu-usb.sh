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
    led2_green
    echo "" | fbv --noinfo /etc/images/done.png
}

display_error ()
{
    echo "...ERROR"
    led2_red
    echo "" | fbv --noinfo /etc/images/error.png
    await_shutdown
}

enable_writeaccess ()
{
    if [ -d "/mnt/usb/autoupdate-settings/" ]; then
        if find /mnt/usb/autoupdate-settings/ -maxdepth 1 -mindepth 1 -type f -iname "writeaccess*" | grep -i "writeaccess"; then
            echo "Modifying fstab for write access"
            sed -i -e '/^[#[:space:]]*\/dev\/root/{s/[[:space:]]ro/ defaults/;s/\([[:space:]]*[[:digit:]]\)\([[:space:]]*\)[[:digit:]]$/\1\20/}' /mnt/rfs_inactive/etc/fstab
        else
            echo "Keeping fstab untouched"
        fi
    else
        echo "Directory autoupdate-settings does not exist"
    fi
}

purge_data ()
{
    OPTION_PURGEDATA="no"
    OPTION_PURGEDATA_IGNORE="no"

    if [ -d "/mnt/usb/autoupdate/" ]; then
        if find /mnt/usb/autoupdate/ -maxdepth 1 -mindepth 1 -type f -iname "*-purgedata.rootfs.tar.xz" | grep -i "purgedata.rootfs.tar.xz"; then
            OPTION_PURGEDATA="yes"
            echo "Request for purgedata via /mnt/usb/autoupdate/*-purgedata.rootfs.tar.xz"
        else
            echo "No request for purgedata via /mnt/usb/autoupdate/*-purgedata.rootfs.tar.xz"
        fi
    else
        echo "Directory autoupdate does not exist"
    fi

    if [ -d "/mnt/usb/autoupdate-settings/" ]; then
        if find /mnt/usb/autoupdate-settings/ -maxdepth 1 -mindepth 1 -type f -iname "purgedata*" | grep -i "purgedata"; then
            OPTION_PURGEDATA="yes"
            echo "Request for purgedata via /mnt/usb/autoupdate-settings/purgedata*"
        else
            echo "No request for purgedata via /mnt/usb/autoupdate-settings/purgedata*"
        fi
    else
        echo "Directory autoupdate-settings does not exist"
    fi

    if [[ "$(cat /tmp/8001.rcg)" =~ true ]]; then
        echo "locked is true: purgedata will be ignored!"
        OPTION_PURGEDATA_IGNORE="yes"
    else
        echo "locked is false"
    fi
    if [[ "$(cat /tmp/8002.rcg)" =~ true ]]; then
        echo "theft is true: purgedata will be ignored!"
        OPTION_PURGEDATA_IGNORE="yes"
    else
        echo "theft is false"
    fi

    if [ "$OPTION_PURGEDATA" == "yes" ]; then
        echo "Purgedata option is selected"
        if [ "$OPTION_PURGEDATA_IGNORE" == "no" ]; then
            echo "Purging data partition"
            rm -rf /mnt/data/*
            echo "...done"
        else
            echo "Keeping data partition"
        fi

    else
        echo "Purgedata option is not selected"
    fi

    if [ ! -d "/mnt/usb/autoupdate/" ] && [ ! -d "/mnt/usb/autoupdate-settings/" ]; then
        echo "Neither directory autoupdate nor directory autoupdate-settings exists"
        return 1 # fail in case neither autoupdate nor autoupdate-settings is present (e.g. by pulling usb prematurely after the copy procedure)
    fi
}

umount_usb ()
{
    echo "Unmounting usb..."
    if umount /mnt/usb; then
        echo "...done"
    fi
}

await_shutdown ()
{
    echo "Waiting for touch event..."
    while evtest --query /dev/input/event0 EV_KEY BTN_TOUCH; do
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
        umount_usb
        display_done
        await_shutdown
    else
        display_error
    fi
}

firstTarXz="/mnt/usb/autoupdate/$(ls /mnt/usb/autoupdate | grep .tar.xz | head -n 1)"
if [[ $firstTarXz =~ .*medusa-image-[a-zA-Z0-9.-]+.rootfs.tar.xz$ ]]; then
    echo "Firmware tarball $firstTarXz found"
    if [[ ${firstTarXz/-purgedata/} =~ .*$(cat /etc/medusa-version).rootfs.tar.xz$ ]]; then
        echo "Nothing to up- or downgrade"
        exit 0
    else
        echo "Stopping DataServer application..." # also stops DataServer based applications
        until ! systemctl is-active medusa-DataServer.service
        do
            systemctl stop medusa-DataServer.service || true
            sleep 1
        done
        echo "...done"
        echo "100" 2> /dev/null > /sys/class/backlight/background/brightness
        echo "Verifying signature..."
        led1_blue
        led2_off
        TERM=linux clear > /dev/tty1 < /dev/tty1
        echo 0 > /sys/class/graphics/fbcon/rotate_all
        /usr/sbin/setfont /usr/share/consolefonts/cp850-8x16.psfu.gz -C /dev/tty1
        TERM=linux setterm -blank 0 -powerdown 0 -powersave off > /dev/tty1 < /dev/tty1
        echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" > /dev/tty1
        echo "" | fbv --noinfo /etc/images/busy.png
        echo -n "${firstTarXz: -44:-14}" > /dev/tty1
        if pv -F "Verifying:  %p" "$firstTarXz" 2> /dev/tty1 | gpgv --keyring /etc/gnupg/pubring.gpg "$firstTarXz.sig" -; then
            if mountpoint -q /mnt/rfs_inactive; then
                echo "...done"
                led2_blue
                echo "Cleaning up inactive partition..."
                if find /mnt/rfs_inactive -mindepth 1 -maxdepth 1 -exec rm -r {} +; then
                    echo "...done"
                    echo "Extracting firmware..."
                    if pv -F "Extracting: %p" "$firstTarXz" 2> /dev/tty1 | tar -xJf - -C /mnt/rfs_inactive --warning=no-timestamp; then
                        echo "...done"
                        enable_writeaccess
                        echo "Syncing..."
                        echo -ne "Syncing...\r" > /dev/tty1
                        if sync; then
                            echo "...done"
                            echo "Purging data partition if desired and allowed..."
                            if purge_data; then
                                echo "...done"
                                echo "Swapping active partition..."
                                if df / | grep 'ubi0:part0'; then
                                    part1_active
                                elif df / | grep 'ubi0:part1'; then
                                    part0_active
                                else
                                    display_error
                                fi
                            else
                                display_error
                            fi
                        else
                            display_error
                        fi
                    else
                        display_error
                    fi
                else
                    systemctl reload mnt-rfs.service
                    display_error
                fi
            else
                display_error
            fi
        else
            display_error
        fi
    fi
else
    echo "autoupdate folder does not contain the required file"
fi
