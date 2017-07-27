FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://wvdial.conf \
"

do_install_append() {
    install -m 0644 ${WORKDIR}/wvdial.conf ${D}/${sysconfdir}
}
