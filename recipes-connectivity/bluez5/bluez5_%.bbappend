FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://bluetooth.service.in.patch \
            file://main.conf \
            file://TIInit_6.7.16.bts \
"

FILES_${PN}_append = " ${base_libdir}/firmware/ti-connectivity/*.bts"

do_install_append() {
    install -d ${D}/${base_libdir}/firmware/ti-connectivity
    install -m 0644 ${WORKDIR}/TIInit_6.7.16.bts ${D}/${base_libdir}/firmware/ti-connectivity

    install -m 0644 ${WORKDIR}/main.conf ${D}/${sysconfdir}/bluetooth/
}
