FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://defconfig.cfg \
"

SRC_URI_remove = "file://syslog.cfg"

RRECOMMENDS_${PN} = ""

INSANE_SKIP_${PN} += "already-stripped"
