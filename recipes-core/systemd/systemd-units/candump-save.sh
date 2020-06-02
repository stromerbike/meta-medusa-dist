#!/bin/bash

if [ $# -eq 0 ]; then
    echo "<4>No file name specified"
    exit 1
fi

if mkdir "/tmp/candump.lock"; then
    echo "No candump-save service is already active"
else
    echo "A candump-save service is already active"
    exit 0
fi

dir="/tmp/candump/"
name="$1"

if [ "$name" != "manual" ]; then
    echo "Waiting for 10 seconds to obtain some more candump"
    sleep 10
fi

echo "Commanding multilog to rotate logs and waiting up to 10s..."
inotifywait -t 10 -e attrib /tmp/candump/current &>/dev/null &
pkill -SIGALRM -fx "/usr/bin/multilog .* /tmp/candump" &
wait
echo "...done"

unset -v latest
unset -v previousLatest
for file in "$dir"*; do
    if [[ $file == $dir@* ]]; then
        [[ $file -nt $latest ]] && previousLatest=$latest && latest=$file
    fi
done

# Remark: If this service was called before multilog has rotated logs at least once
# on its own, previousLatest will be empty and thus cat will only take latest.
if [ "$name" == "manual" ]; then
    echo "Concatenating $previousLatest $latest and saving as full length PCAN trace file /mnt/data/candump/$name.trc"
    cat "$previousLatest" "$latest" > "$dir$name.candump"
else
    echo "Concatenating $previousLatest $latest and saving as size limited PCAN trace file /mnt/data/candump/$name.trc"
    cat "$previousLatest" "$latest" | tail -n 10000 > "$dir$name.candump"
fi

if [ "$name" == "manual" ]; then
    TERM=linux clear > /dev/tty1 < /dev/tty1
    echo 0 > /sys/class/graphics/fbcon/rotate_all
    /usr/sbin/setfont /usr/share/consolefonts/cp850-8x16.psfu.gz -C /dev/tty1
    TERM=linux setterm -blank 0 -powerdown 0 -powersave off > /dev/tty1 < /dev/tty1
    echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" > /dev/tty1
    echo "" | fbv --noinfo /etc/images/busy.png
    echo "${previousLatest: -30}" > /dev/tty1
    echo "${latest: -30}" > /dev/tty1
    pv -F "Saving: %p" "$dir$name.candump" 2> /dev/tty1 | awk -f /etc/scripts/candump.awk - > "$dir$name.trc"
    TERM=linux clear > /dev/tty1 < /dev/tty1
else
    awk -f /etc/scripts/candump.awk "$dir$name.candump" > "$dir$name.trc"
fi

rm "$dir$name.candump"
mkdir -p /mnt/data/candump
if [ ! -e "/tmp/candump.first" ]; then
    cp "$dir$name.trc" "/mnt/data/candump/first.trc"
    mkdir "/tmp/candump.first"
fi
mv -f "$dir$name.trc" "/mnt/data/candump/$name.trc"

rm -r "/tmp/candump.lock"
