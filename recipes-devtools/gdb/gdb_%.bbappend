FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://remove-non-arm-files.patch \
"

PACKAGECONFIG:remove = " python"
