#!/bin/bash

HOSTNAME="$(/etc/scripts/hostname.sh)"
echo "$HOSTNAME" | tee /mnt/data/hostname
hostname $ID
