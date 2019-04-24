#!/bin/bash

if [ $# -eq 0 ]; then
    echo "<4>No file name specified"
    exit 1
fi

if mkdir "/tmp/candump.lock"; then
    echo "No candump-save service is already active"
else
    echo "<4>A candump-save service is already active"
    exit 1
fi

dir="/tmp/candump/"
name="$1"

inotifywait -t 10 -e attrib /tmp/candump/current &>/dev/null &
pkill -SIGALRM multilog &
wait

unset -v latest
unset -v previousLatest
for file in "$dir"*; do
    if [[ $file == $dir@* ]]; then
        [[ $file -nt $latest ]] && previousLatest=$latest && latest=$file
    fi
done

echo "Concatenating $previousLatest $latest and saving as xz-compressed PCAN trace file /mnt/data/candump/$name.trc.xz"
cat $previousLatest $latest > $dir$name.candump
awk -f /etc/scripts/candump.awk $dir$name.candump > $dir$name.trc
rm $dir$name.candump
mkdir -p /mnt/data/candump
mv $dir$name.trc /mnt/data/candump

rm -r "/tmp/candump.lock"
