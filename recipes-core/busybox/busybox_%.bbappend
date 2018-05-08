FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://defconfig.cfg \
"

INSANE_SKIP_${PN} += "already-stripped"
