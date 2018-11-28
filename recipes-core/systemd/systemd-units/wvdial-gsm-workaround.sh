#!/bin/bash

# Read out any garbage from ttyACM0
if ls -l `which timeout` | grep busybox > /dev/null; then
    echo "Timeout provided by busybox"
    timeout -t 1 microcom /dev/ttyACM0 &>/dev/null || true
else
    echo "Timeout provided by coreutils"
    timeout 1 microcom /dev/ttyACM0 &>/dev/null || true
fi
