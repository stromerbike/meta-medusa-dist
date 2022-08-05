#!/bin/bash

if [ $# -eq 0 ]; then
    echo "<4>No file name specified"
    exit 1
fi

NAME="$1"
TMPDIR="/tmp/candump"
DATADIR="/mnt/data/candump"
USBDATADIR="/mnt/usb/candump"
NUMFILESMAX=50

terminationRequested=0
function catchTerminationRequest() {
    echo "SIGTERM caught"
    terminationRequested=1
}
trap catchTerminationRequest SIGTERM

if [ "$NAME" == "manual" ]; then
    TMPDIR="/tmp/candump-manual"
else
    if mkdir "/tmp/candump.lock"; then
        echo "No non-manual candump-save service is already active"
    else
        echo "A non-manual candump-save service is already active"
        exit 0
    fi
    echo "Waiting for 10 seconds to obtain some more candump..."
    counter=0
    while [ $counter -lt 10 ] && [ $terminationRequested -eq 0 ];
    do
        let counter=counter+1
        sleep 1
    done
    if [ $terminationRequested -eq 0 ]; then
        echo "...done"
    else
        echo "...skipped"
    fi
fi

echo "Commanding multilog to rotate logs and waiting up to 10s..."
inotifywait -t 10 -e attrib "$TMPDIR/state" &>/dev/null &
pkill -SIGALRM -fx "/usr/bin/multilog .* $TMPDIR" &
wait
echo "...done"

# Remark: If this service was called before multilog has rotated logs at least once
# on its own, previousLatest will be empty and thus cat will only take latest.
unset -v latest
unset -v previousLatest
for file in "$TMPDIR/"*; do
    if [[ $file == "$TMPDIR/@"* ]]; then # rotated multilog files are prefixed with an @
        [[ $file -nt $latest ]] && previousLatest=$latest && latest=$file
    fi
done

if [ "$NAME" == "manual" ]; then
    TERM=linux clear > /dev/tty1 < /dev/tty1
    echo 0 > /sys/class/graphics/fbcon/rotate_all
    /usr/sbin/setfont /usr/share/consolefonts/cp850-8x16.psfu.gz -C /dev/tty1
    TERM=linux setterm -blank 0 -powerdown 0 -powersave off > /dev/tty1 < /dev/tty1
    echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" > /dev/tty1
    echo "" | fbv --noinfo /etc/images/busy.png
    if [ -d "$USBDATADIR" ]; then
        echo "Concatenating all chunks to $USBDATADIR/$NAME.candump..."
        ls -1tr "$TMPDIR/"*.lzo | xargs lzop -dc | pv -F "Saving: %p %b" 2> /dev/tty1 > "$USBDATADIR/$NAME.candump"
        echo "...done"
        TMPDIR="$USBDATADIR"
        echo "Setting TMPDIR to $USBDATADIR"
        cp /etc/scripts/candump.awk "$USBDATADIR"
        cp /usr/share/gnuwin/awk.exe "$USBDATADIR"
        echo "awk.exe -f candump.awk manual.candump > manual.trc" > "$USBDATADIR/convert.bat"
        echo "awk -f candump.awk manual.candump > manual.trc" > "$USBDATADIR/convert.sh"
        echo "Syncing..."
        if sync; then
            echo "...done"
        fi
        if df -T | grep "/mnt/usb" | grep "fuseblk"; then
            echo "Unmounting (-f) usb..."
            if umount -f /mnt/usb; then
                echo "...done"
            fi
        else
            echo "Unmounting usb..."
            if umount /mnt/usb; then
                echo "...done"
            fi
        fi
    else
        echo "Concatenating up to 10 chunks to $TMPDIR/$NAME.candump..."
        ls -1tr "$TMPDIR/"*.lzo | tail -n 10 | xargs lzop -dc > "$TMPDIR/$NAME.candump"
        echo "...done"
        echo "Converting $TMPDIR/$NAME.candump to PCAN trace file $TMPDIR/$NAME.trc..."
        pv -F "Converting: %p" "$TMPDIR/$NAME.candump" 2> /dev/tty1 | awk -f /etc/scripts/candump.awk - > "$TMPDIR/$NAME.trc"
        echo "...done"
    fi
    TERM=linux clear > /dev/tty1 < /dev/tty1
elif [ "$NAME" == "update" ]; then
    echo "Concatenating $previousLatest $latest with a maximum length of 100000 to $TMPDIR/$NAME.candump..."
    cat "$previousLatest" "$latest" | tail -n 100000 > "$TMPDIR/$NAME.candump"
    echo "...done"
else
    echo "Concatenating $previousLatest $latest with a maximum length of 10000 to $TMPDIR/$NAME.candump..."
    cat "$previousLatest" "$latest" | tail -n 10000 > "$TMPDIR/$NAME.candump"
    echo "...done"
fi

if [ "$NAME" != "manual" ]; then
    echo "Converting $TMPDIR/$NAME.candump to PCAN trace file $TMPDIR/$NAME.trc..."
    awk -f /etc/scripts/candump.awk "$TMPDIR/$NAME.candump" > "$TMPDIR/$NAME.trc"
    echo "...done"
fi

if [ "$TMPDIR" != "$USBDATADIR" ]; then
    rm -v "$TMPDIR/$NAME.candump"
else
    echo "Keeping $TMPDIR/$NAME.candump"
fi

mkdir -p $DATADIR
echo "Scanning $DATADIR for latest sequence number and creating a list of files..."
latestSeqNum=0
declare -a files=()
for file in "$DATADIR/"*; do
    filename="${file##*/}"
    if [[ $filename =~ ^([0-9]{9})_ ]]; then
        seqNum=$((10#${BASH_REMATCH[1]}))
        [ $seqNum -gt $latestSeqNum ] && latestSeqNum=$seqNum
    fi
    if [ "$filename" != "first.trc" ] && [ "$filename" != "manual.trc" ] && [ "$filename" != "update.trc" ]; then
        files[${#files[@]}]="$file"
    else
        echo "while skipping $file"
    fi
done
nextSeqNum="$(printf "%09u" $((latestSeqNum+1)))"
echo "...done. Latest: $(printf "%09u" $latestSeqNum), Next: $nextSeqNum, Files: ${#files[@]}"

if [ ${#files[@]} -ge $NUMFILESMAX ]; then
    echo "Removing files until amount is reduced to $((NUMFILESMAX-1)))..."
    readarray -t sortedFiles < <(printf '%s\n' "${files[@]}" | sort -r)
    numFiles=0
    for file in "${sortedFiles[@]}"
    do
        if [[ ! $file =~ [0-9]{9}_ ]]; then
            echo "Found legacy file: $file"
            rm -v "$file"
        else
            numFiles=$((numFiles+1))
            if [ $numFiles -ge $NUMFILESMAX ]; then
               rm -v "$file"
            fi
        fi
    done
    echo "...done"
fi

if [ "$NAME" != "manual" ] && [ "$NAME" != "update" ]; then
    if [ ! -e "/tmp/candump.first" ]; then
        echo "Copying PCAN trace file as $DATADIR/first.trc to persistent storage..."
        cp "$TMPDIR/$NAME.trc" "$DATADIR/first.trc"
        mkdir "/tmp/candump.first"
        echo "...done"
    fi
    echo "Moving PCAN trace file as $DATADIR/${nextSeqNum}_$NAME.trc to persistent storage..."
    mv -f "$TMPDIR/$NAME.trc" "$DATADIR/${nextSeqNum}_$NAME.trc"
    echo "...done"
else
    if [ "$TMPDIR" != "$USBDATADIR" ]; then
        echo "Moving PCAN trace file as $NAME.trc to persistent storage..."
        mv -f "$TMPDIR/$NAME.trc" "$DATADIR/$NAME.trc"
        echo "...done"
    else
        echo "PCAN trace file $NAME.trc already on persistent storage"
    fi
fi

if [ "$NAME" != "manual" ]; then
    rm -r "/tmp/candump.lock"
fi
