#!/bin/bash

source /etc/scripts/rc-setter.sh

# The watchdog timeout should be set to a value well above PollIntervalMaxSec of systemd-timesyncd.
# Even though PollIntervalMaxSec is expected to work reliably, NTP uses UDP and messages might, but
# likely will get lost (according to tests).
WATCHDOG_TIMEOUT=1800

# NTP is used already and the generated (UDP) messages are relatively small.
# Using the status/timestamp of the last NTP synchronization for kicking the watchdog,
# allows the consumed data volume to be used for two purposes.
# The reasoning of coupling the watchdog logic to the NTP servers can be argued with both DNS
# servers (10.89.23.40 and 10.89.23.41) also serving NTP clients via ntp-00.stromer.internal
# and ntp-01.stromer.internal; If there is an outage of both servers, no DNS requests would
# be served and the device connectivity be degraded anyway.
SYNC_FILE="/run/systemd/timesync/synchronized"

# To not timeout the watchdog on isolated NTP issues alone, a failed port check to both
# DNS servers is required as well before action is taken.
DNS_SERVER_PRIMARY="10.89.23.40"
DNS_SERVER_SECONDARY="10.89.23.41"
DNS_SERVER_PORT=53
DNS_SERVER_TIMEOUT=60

# Simulation of error cases:
# - Dialed-in & ipv4 assigned but no connectivity/route:
#   -> "ip route del default dev ppp0"
# - Modem does not react to AT commands (more interesting for wvdial service):
#   -> "pkill -SIGKILL pppd"
# - The PPP daemon has died: A modem hung up the phone (exit code = 16) (more interesting for wvdial service):
#   -> pause SIM in M2M portal

# Remarks: - Although pppd is solely used for the mobile connectivity,
#            it is cleaner to only consider PID's within the correct cgroup.
#          - Whereas the graceful termination of pppd upon a watchdog timeout,
#            is the least invasive method to trigger a re-dial, or a modem reset
#            as deemed necessary by wvdial*.service, it is not (yet) clear if
#            different measures should be carried out to handle any cases that are possible.
terminatePppd ()
{
    for pid in $(cat /sys/fs/cgroup/systemd/system.slice/wvdial*/cgroup.procs); do
        if grep -q pppd "/proc/$pid/cmdline"; then
            echo "Terminating pppd ($pid)..."
            if kill -SIGTERM $pid; then
                echo "...done"
            else
                echo "...error"
            fi
        fi
    done
}

while true;
do
    # The file does not exist until the time has been synchronized and systemd-timesyncd is (still) running.
    # In case the time was never synchronized or there is an issue with systemd-timesyncd but the DNS
    # servers are working, no action is taken due to this check.
    # The usage of the DNS servers as primary method and not only as a fallback ones, could be considered.
    # This would allow to still perform the watchdog operation in case the NTP servers are down.
    if [ -e "$SYNC_FILE" ]; then
        inotifywait -t $WATCHDOG_TIMEOUT "$SYNC_FILE" &>/dev/null
        if [ $? -ne 0 ]; then
            echo "No event detected on $SYNC_FILE for ${WATCHDOG_TIMEOUT}s"
            if ! nc -zv -w "$DNS_SERVER_TIMEOUT" "$DNS_SERVER_PRIMARY" "$DNS_SERVER_PORT" >/dev/null; then
                echo "$DNS_SERVER_PRIMARY port not open"
                if ! nc -zv -w "$DNS_SERVER_TIMEOUT" "$DNS_SERVER_SECONDARY" "$DNS_SERVER_PORT" >/dev/null; then
                    echo "$DNS_SERVER_SECONDARY not open"
                    timeout_timestamp=$(date -u +%s)
                    echo "Watchdog timeout at: $timeout_timestamp ($(date -d @$timeout_timestamp +"%Y-%m-%d %H:%M:%S"))"
                    recordCommanderSetter "set 98121: $timeout_timestamp"
                    terminatePppd
                    exit 0
                else
                    echo "But $DNS_SERVER_SECONDARY port open (primary DNS issue?)"
                    sleep 600
                fi
            else
                echo "But $DNS_SERVER_PRIMARY port open (NTP issue?)"
                sleep 600
            fi
        else
            synchronized_file_mtime=$(stat -c %Y "$SYNC_FILE")
            recordCommanderSetter "set 98120: $synchronized_file_mtime" >/dev/null
        fi
    else
        sleep 60
    fi
done
