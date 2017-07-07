FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://wvdial.conf \
            file://wvdial.service \
"

FILES_${PN}_append += "${systemd_system_unitdir}/*"

do_install_append() {
    install -m 0644 ${WORKDIR}/wvdial.conf ${D}/${sysconfdir}

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/wvdial.service ${D}/${systemd_system_unitdir}
}
