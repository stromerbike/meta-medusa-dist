FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://defconfig.cfg \
"

SRC_URI:remove = "file://syslog.cfg"

RRECOMMENDS:${PN} = ""

INSANE_SKIP:${PN} += "already-stripped"

do_install:prepend() {
    if grep -q "CONFIG_FEATURE_INDIVIDUAL=y" ${B}/.config; then
        install -d ${D}${base_sbindir} ${D}${sbindir}
    fi
}
