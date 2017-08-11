#! /bin/bash

NAME=fwu
DESC="Firmware update over USB"

led1_blue ()
{
    echo "255" > /sys/class/leds/rgb1_blue/brightness
    echo "0" > /sys/class/leds/rgb1_green/brightness
    echo "0" > /sys/class/leds/rgb1_red/brightness
}

led1_off ()
{
    echo "0" > /sys/class/leds/rgb1_blue/brightness
    echo "0" > /sys/class/leds/rgb1_green/brightness
    echo "0" > /sys/class/leds/rgb1_red/brightness
}

led2_blue ()
{
    echo "255" > /sys/class/leds/rgb2_blue/brightness
    echo "0" > /sys/class/leds/rgb2_green/brightness
    echo "0" > /sys/class/leds/rgb2_red/brightness
}

led2_green ()
{
    echo "0" > /sys/class/leds/rgb2_blue/brightness
    echo "255" > /sys/class/leds/rgb2_green/brightness
    echo "0" > /sys/class/leds/rgb2_red/brightness
}

led2_red ()
{
    echo "0" > /sys/class/leds/rgb2_blue/brightness
    echo "0" > /sys/class/leds/rgb2_green/brightness
    echo "255" > /sys/class/leds/rgb2_red/brightness
}

led2_off ()
{
    echo "0" > /sys/class/leds/rgb2_blue/brightness
    echo "0" > /sys/class/leds/rgb2_green/brightness
    echo "0" > /sys/class/leds/rgb2_red/brightness
}

case $1 in
start)
    if [ -d "/mnt/sda/autoupdate" ] || [ -d "/mnt/sda1/autoupdate" ]; then
        led1_blue
        firstFile=""
        if [ -d "/mnt/sda/autoupdate" ]; then
            firstFile="/mnt/sda/autoupdate/$(ls /mnt/sda/autoupdate | head -n 1)"
        else
            firstFile="/mnt/sda1/autoupdate/$(ls /mnt/sda1/autoupdate | head -n 1)"
        fi
        if [[ $firstFile =~ .*medusa-image-[a-zA-Z0-9.-]+.rootfs.tar.gz$ ]]; then
            echo "Firmware $firstFile found"
            if [[ $firstFile =~ .*$(cat /usr/bin/medusa/version).rootfs.tar.gz$ ]]; then
                echo "Nothing to up- or downgrade"
                led2_green
            else
                if mountpoint -q /mnt/rfs_inactive; then
                    echo "Stopping DataServer based applications..."
                    systemctl stop medusa-DataServer
                    echo "Purging files on inactive rfs partition..."
                    led2_blue
                    fbi --noverbose -T 1 /etc/images/busy.png
                    rm -rvf /mnt/rfs_inactive/* 2>&1 |
                        while read line; do
                            x=$((x+1))
                            if [ $(($x%100)) -eq 0 ]; then
                                if [ $(cat /sys/class/leds/rgb2_blue/brightness) == "0" ]; then
                                    echo "255" > /sys/class/leds/rgb2_blue/brightness
                                else
                                    echo "0" > /sys/class/leds/rgb2_blue/brightness
                                fi
                            fi
                        done
                    echo "...done"
                    echo "Extracting firmware..."
                    tar -xvf $firstFile -C /mnt/rfs_inactive 2>&1 |
                        while read line; do
                            x=$((x+1))
                            if [ $(($x%100)) -eq 0 ]; then
                                if [ $(cat /sys/class/leds/rgb2_blue/brightness) == "0" ]; then
                                    echo "255" > /sys/class/leds/rgb2_blue/brightness
                                else
                                    echo "0" > /sys/class/leds/rgb2_blue/brightness
                                fi
                            fi
                        done
                    echo "...done"
                    led2_blue
                    echo "Unmounting inactive rfs paritition..."
                    if umount /mnt/rfs_inactive; then
                        echo "...done"
                        if df -T | grep 'ubi0:part0'; then
                            echo "Setting partition 1 as active one..."
                            if barebox-state -s partition=1; then
                                echo "...done"
                                fbi --noverbose -T 1 /etc/images/done.png
                                led2_green
                                break
                            else
                                echo "...ERROR"
                                led2_red
                                fbi --noverbose -T 1 /etc/images/error.png
                                break
                            fi
                        elif df -T | grep 'ubi0:part1'; then
                            echo "Setting partition 0 as active one..."
                            if barebox-state -s partition=0; then
                                echo "...done"
                                fbi --noverbose -T 1 /etc/images/done.png
                                led2_green
                                break
                            else
                                echo "...ERROR"
                                led2_red
                                fbi --noverbose -T 1 /etc/images/error.png
                                break
                            fi
                        else
                            echo "...ERROR"
                            led2_red
                            fbi --noverbose -T 1 /etc/images/error.png
                            break
                        fi
                    else
                        echo "...ERROR"
                        led2_red
                        fbi --noverbose -T 1 /etc/images/error.png
                        break
                    fi
                else
                    echo "ERROR: Inactive rfs paritition not mounted"
                    led2_red
                    fbi --noverbose -T 1 /etc/images/error.png
                fi
            fi
        fi
    fi
;;

stop)
    led1_off
    led2_off
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
