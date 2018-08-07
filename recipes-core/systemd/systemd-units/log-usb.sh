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

if [ -d "/mnt/sda1/log" ]; then
    led1_blue

    echo "Starting DataServer..."
    systemctl start medusa-DataServer || true
    echo "...done"

    if ls -l `which timeout` | grep busybox > /dev/null; then
        TIMEOUT_CMD="timeout -s KILL -t 5"
    else
        TIMEOUT_CMD="timeout -s KILL 5"
    fi
    if [[ "$($TIMEOUT_CMD /usr/bin/medusa/RecordCommander/RecordCommander /usr/bin/medusa/TargetIpcConfiguration.json "get \"imsi\"")" =~ \"([0-9]+)\" ]]; then
        IDENTIFIER="${BASH_REMATCH[1]}"
    elif [[ "$($TIMEOUT_CMD /usr/bin/medusa/RecordCommander/RecordCommander /usr/bin/medusa/TargetIpcConfiguration.json "get \"stromerLabel\"")" =~ \"([a-zA-Z0-9-]+)\" ]]; then
        IDENTIFIER="${BASH_REMATCH[1]}"
    else
        IDENTIFIER="unknown"
    fi

    DATE="$(date --utc +"%Y-%m-%d-%H%M%S")"

    LOGFILE="/mnt/sda1/log/${IDENTIFIER}_${DATE}_$(cat /etc/medusa-version).zip"

    echo -n "Writing log to $LOGFILE..."
    led2_blue
    if journalctl -o short --no-hostname | gzip --fast > $LOGFILE; then
        echo "done ($(stat -c%s $LOGFILE) bytes written)"
        echo "Unmounting sda1..."
        if umount /mnt/sda1; then
            echo "...done"
        fi
        led1_off
        led2_off
        exit 0
    else
        echo "ERROR ($(stat -c%s $LOGFILE) bytes written)"
        led2_red
        exit 1
    fi
fi
