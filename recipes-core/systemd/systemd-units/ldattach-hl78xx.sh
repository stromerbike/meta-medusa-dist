#!/bin/dash

if lsusb -d 1199:c001; then
    echo "HL78xx in USB mode. No serial line discipline needed."
    exit 0
else
    echo "HL78xx in UART mode. Attaching serial line discipline."
    /bin/echo -e "AT+CMUX=0,0,7\r" | picocom -qr -b 115200 -f h -x 1000 /dev/ttymxc7
    modprobe n_gsm debug=0x2
    ldattach -d -8n1 -s 460800 GSM0710 /dev/ttymxc7
fi
