FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://defconfig.cfg \
"

SYSTEMD_AUTO_ENABLE_${PN}-syslog = "disable"

INSANE_SKIP_${PN} += "already-stripped"
