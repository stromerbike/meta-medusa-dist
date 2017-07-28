#! /bin/bash

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

while true
do
    sleep 5
    if [ -d "/mnt/sda1/autoupdate" ]; then
        led1_blue
        firstFileName=$(ls /mnt/sda1/autoupdate | head -n 1)
        if [[ $firstFileName =~ ^medusa-image-[a-zA-Z0-9.-]+.rootfs.tar.gz$ ]]; then
            echo "Firmware $firstFileName found"
            if [[ $firstFileName =~ .*$(cat /usr/bin/medusa/version).* ]]; then
                echo "Nothing to up- or downgrade"
                led2_green
            else
                echo "Purging files on inactive rfs partition..."
                led2_blue
                if rm -rf /mnt/rfs_inactive/*; then
                    echo "...done"
                    echo "Extracting firmware..."
                    if tar -xvf /mnt/sda1/autoupdate/$firstFileName -C /mnt/rfs_inactive 2>&1 |
                        while read line; do
                            x=$((x+1))
                            if [ $(($x%2)) -eq 0 ]; then
                                echo "0" > /sys/class/leds/rgb2_blue/brightness
                            else
                                echo "255" > /sys/class/leds/rgb2_blue/brightness
                            fi
                        done; then
                        echo "...done"
                        if df -T | grep 'ubi0:part0'; then
                            echo "Setting partition 1 as active one..."
                            if barebox-state -s partition=1; then
                                echo "...done"
                                led2_green
                            else
                                echo "...ERROR"
                                led2_red
                            fi
                        elif df -T | grep 'ubi0:part1'; then
                            echo "Setting partition 0 as active one..."
                            if barebox-state -s partition=0; then
                                echo "...done"
                                led2_green
                            else
                                echo "...ERROR"
                                led2_red
                            fi
                        else
                            echo "...ERROR"
                            led2_red
                        fi
                    else
                        echo "...ERROR"
                        led2_red
                    fi
                else
                    echo "...ERROR"
                    led2_red
                fi
                break
            fi
        fi
    else
        led1_off
    fi
done
