#!/bin/bash

if df -T | grep 'ubi0:part0'; then
    echo "part0 is mounted as active one"
    if barebox-state -s partition=1; then
        echo "part1 will be mounted as active one after reboot"
        exit 0
    else
        echo "active partition could not be changed"
        exit 1
    fi
elif df -T | grep 'ubi0:part1'; then
    echo "part1 is mounted as active one"
    if barebox-state -s partition=0; then
        echo "part0 will be mounted as active one after reboot"
        exit 0
    else
        echo "active partition could not be changed"
        exit 1
    fi
else
    echo "active partition could not be determined"
    exit 1
fi
