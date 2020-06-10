#!/bin/bash

if [ $# -eq 0 ]; then
    echo "<4>No file name specified"
    exit 1
fi

if mkdir "/tmp/interceptty.lock"; then
    echo "No interceptty-save service is already active"
else
    echo "An interceptty-save service is already active"
    exit 0
fi

dir="/tmp/interceptty/"
name="${1##*/}"

echo "Commanding multilog to rotate logs and waiting up to 10s..."
inotifywait -t 10 -e attrib /tmp/interceptty/current &>/dev/null &
pkill -SIGALRM -fx "/usr/bin/multilog .* /tmp/interceptty" &
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
echo "Concatenating $previousLatest $latest and saving as log file /mnt/data/interceptty/$name.log"
mkdir -p /mnt/data/interceptty
cat "$previousLatest" "$latest" > "/mnt/data/interceptty/$name.log"

rm -r "/tmp/interceptty.lock"
