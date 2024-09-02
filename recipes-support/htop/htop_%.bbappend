FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://0001-remove-desktop-file-and-icon.patch \
"

PACKAGECONFIG:remove = " delayacct"
