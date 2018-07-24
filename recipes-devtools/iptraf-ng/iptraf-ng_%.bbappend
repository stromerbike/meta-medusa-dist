FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://ports.dat \
"

do_install_append() {
    install -d ${D}${localstatedir}/lib/${PN}
    install -m 0644 ${WORKDIR}/ports.dat ${D}${localstatedir}/lib/${PN}/ports.dat
}
