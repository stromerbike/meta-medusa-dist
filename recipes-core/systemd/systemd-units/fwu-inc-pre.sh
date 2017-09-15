#! /bin/bash

#TODO: add firmware delta (includes checksum) and in tar.gz and ubifs image

NAME=fwu-inc-pre
DESC="Preparation for incremental firmware update"

case $1 in
start)
    if df | grep '/mnt/rfs_inactive'; then
        if df | grep '/mnt/zram'; then
            echo "Checking for already valid original firmware tarball..."
            if TMPDIR="/mnt/zram" pristine-tar validate /mnt/rfs_inactive/$(cat /etc/medusa-version).tar /tmp/fw.delta; then
                echo "...present"
            else
                echo "Cleaning up inactive partition..."
                if rm -rf /mnt/rfs_inactive/*; then
                    echo "...done"
                    echo "Recreating original firmware tarball..."
                    if cd / && TMPDIR="/mnt/zram" TMPDIR_SRC="/mnt/rfs_inactive" TMPDIR_TAR="/mnt/zram" pristine-tar gentar /tmp/fw.delta /mnt/rfs_inactive/$(cat /etc/medusa-version).tar; then
                        echo "...done"
                    else
                        echo "...ERROR"
                    fi
                else
                    echo "...ERROR"
                fi
            fi
        else
            echo "ERROR: zram is not available"
        fi
    else
        echo "ERROR: inactive partition not mounted"
    fi
;;

*)
    echo "Usage $0 start"
    exit
esac
