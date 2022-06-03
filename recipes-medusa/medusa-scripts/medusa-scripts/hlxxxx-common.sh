#!/bin/bash

###
# Realizes a forceful shutdown (KILL) of the application accessing the given interface.
# Also removes any potentially existing interface lock.
# Globals:
#   INTERFACE (readonly)
# Arguments: -
# Outputs:
#   Whatever "fuser" and/or "rm" outputs.
# Returns: -
###
function prepareComport() {
    if [ -e "/dev/$INTERFACE" ]; then
        fuser -k "/dev/$INTERFACE"
    fi
    if [ -e "/var/lock/LCK..$INTERFACE" ]; then
        rm -fv "/var/lock/LCK..$INTERFACE"
    fi
}

###
# Realizes a graceful shutdown (TERM) of the application accessing the given interface.
# Globals:
#   INTERFACE (readonly)
# Arguments: -
# Outputs:
#   Whatever "fuser" outputs.
# Returns: -
###
function cleanupComport() {
    if [ -e "/dev/$INTERFACE" ]; then
        fuser -s -k -TERM "/dev/$INTERFACE"
    fi
}
