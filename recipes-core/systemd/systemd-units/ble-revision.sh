#!/bin/bash

# detection
# https://e2e.ti.com/support/wireless-connectivity/bluetooth/f/538/t/542034?distinguish-between-CC2564B-and-CC2564C
OUTPUT=$(hcitool -i hci0 cmd 0x3F 0x021F)
if [[ $OUTPUT =~ 1F\ FE\ 00\ 07\ 10 ]]; then
    echo "<6>CC2564B detected"
elif [[ $OUTPUT =~ 1F\ FE\ 00\ 0C\ 1A ]]; then
    echo "<4>CC2564C detected"
else
    echo "<3>CC2564B/C not detected"
fi
