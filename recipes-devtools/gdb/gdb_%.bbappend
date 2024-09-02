FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://0001-remove-non-arm-files.patch \
"

PACKAGECONFIG:remove = " python"
