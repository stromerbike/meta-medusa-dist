FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://TIInit_6.7.16.bts \
            file://TIInit_6.7.35.bts \
"

FILES_${PN}_append = " ${base_libdir}/firmware/ti-connectivity/*.bts"

do_install_append() {
    install -d ${D}/${base_libdir}/firmware/ti-connectivity
    install -m 0644 ${WORKDIR}/TIInit_6.7.16.bts ${D}/${base_libdir}/firmware/ti-connectivity
    install -m 0644 ${WORKDIR}/TIInit_6.7.35.bts ${D}/${base_libdir}/firmware/ti-connectivity
}
