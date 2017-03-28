FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://system.conf \
"

RDEPENDS_${PN} += "systemd-units"

PACKAGECONFIG_append = " networkd"

do_install_append() {
    install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd
}
