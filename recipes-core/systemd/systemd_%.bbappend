FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://system.conf \
"

do_install_append() {
    install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd
}
