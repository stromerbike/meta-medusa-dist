#!/bin/bash

# Remark: A reverse logic is used for the return value.
#   - Code  0: Module firmware is up to date or there was an error during the check.
#   - Code  1: Module firmware is not up to date.
#   - Code 22: Only if there is an obvious error in usage.
# The aim of the reverse logic is to not indicate an available update on error (such as parsing).

if [ ! -z "$1" ]; then
    echo "CGMR value: $1"
    if [[ $1 =~ ^HL78([0-9]+).([0-9]+.[0-9]+.[0-9]+.[0-9]+) ]]; then
        MODULE_VARIANT="${BASH_REMATCH[1]}"
        CURRENT_REVISION="${BASH_REMATCH[2]}"
        echo "Current HL78$MODULE_VARIANT revision: $CURRENT_REVISION"
        if cd /lib/firmware/sierra-wireless/ && sha256sum -c SHA256SUMS; then
            UPDATE_FILE="$(stat -c %n HL78${MODULE_VARIANT}_${CURRENT_REVISION}_to_*)"
            if [ $? -eq 0 ]; then
                echo "Applicable update file: $UPDATE_FILE"
                exit 1
            else
                echo "No applicable update file found"
            fi
        else
            echo "Checksums not valid"
        fi
    elif [[ $1 =~ ^([A-Z]?)HL85 ]]; then
        echo "Module firmware update for HL85xxx not implemented"
    else
        echo "CGMR value not parseable"
    fi
else
    echo "No CGMR value supplied"
    exit 22
fi

exit 0
