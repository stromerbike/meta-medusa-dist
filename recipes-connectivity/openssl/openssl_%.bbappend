FILES_${PN}_remove_class-target += "${bindir}/*"

do_install_append_class-target() {
    rm -r ${D}${sysconfdir}/ssl/
    rm -r ${D}${libdir}/ssl/
    rm -r ${D}${bindir}/
}
