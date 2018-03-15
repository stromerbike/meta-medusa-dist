FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://gpsd-default \
"

SYSTEMD_AUTO_ENABLE_${PN} = "disable"
