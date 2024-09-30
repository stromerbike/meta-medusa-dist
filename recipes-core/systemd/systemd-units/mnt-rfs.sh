#!/bin/dash

NAME=mnt-rfs
DESC="Mount the inactive rfs partition"

case $1 in
start)
    inactive_partition=""
    if df / | grep 'ubi0:part0'; then
        inactive_partition="/dev/ubi0_1"
    elif df / | grep 'ubi0:part1'; then
        inactive_partition="/dev/ubi0_0"
    fi

    if [ -n "$inactive_partition" ]; then
        echo "Mounting inactive rfs partition $inactive_partition..."
        if mount -t ubifs "$inactive_partition" /mnt/rfs_inactive; then
            echo "Testing writeability..."
            if touch /mnt/rfs_inactive/testfile; then
                echo "Cleaning up..."
                if rm /mnt/rfs_inactive/testfile; then
                    echo "...done"
                    exit 0
                fi
            fi
        fi
        echo "<3>...ERROR"

        umount -v -f /mnt/rfs_inactive || true
        echo "Creating an empty filesystem on $inactive_partition..."
        if mkfs.ubifs -v -y "$inactive_partition"; then
            echo "Re-mounting inactive rfs partition $inactive_partition..."
            if mount -t ubifs "$inactive_partition" /mnt/rfs_inactive; then
                echo "...done"
                exit 0
            fi
        fi
        echo "<3>...ERROR"
    else
        echo "Active partition could not be determined"
    fi
;;

stop)
    echo "Unmounting inactive rfs partition..."
    umount /mnt/rfs_inactive
;;

*)
    echo "Usage $0 {start|stop}"
    exit
esac
