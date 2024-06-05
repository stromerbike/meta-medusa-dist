FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://remove-desktop-file-and-icon.patch \
"

PACKAGECONFIG:remove = " delayacct"
