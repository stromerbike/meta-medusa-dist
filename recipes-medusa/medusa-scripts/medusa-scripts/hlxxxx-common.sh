#!/bin/bash

###
# Brief:
#   Realizes a forceful shutdown (KILL) of the application accessing the given interface.
#   Also removes any potentially existing interface lock.
# Details:
#   Because in most situations no forceful shutdown (KILL) resp. no preparation is required,
#   "|| true" is appended to the fuser call so that a caller script using "set -e" is not terminated.
# Globals:
#   INTERFACE (readonly)
# Arguments: -
# Outputs:
#   Whatever "fuser" and/or "rm" outputs.
# Returns: -
###
function prepareComport() {
    if [ -e "/dev/$INTERFACE" ]; then
        fuser -k "/dev/$INTERFACE" || true
    fi
    if [ -e "/var/lock/LCK..$INTERFACE" ]; then
        rm -fv "/var/lock/LCK..$INTERFACE"
    fi
}

###
# Brief:
#   Realizes a graceful shutdown (TERM) of the application accessing the given interface.
# Details:
#   Because in many situations no graceful shutdown (TERM) resp. no cleanup is required,
#   "|| true" is appended to the fuser call so that a caller script using "set -e" is not terminated.
# Globals:
#   INTERFACE (readonly)
# Arguments: -
# Outputs:
#   Whatever "fuser" outputs.
# Returns: -
###
function cleanupComport() {
    if [ -e "/dev/$INTERFACE" ]; then
        fuser -s -k -TERM "/dev/$INTERFACE" || true
    fi
}
