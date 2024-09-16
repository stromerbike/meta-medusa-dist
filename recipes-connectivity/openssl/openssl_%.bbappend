FILES:${PN}:remove:class-target = " ${bindir}/*"

do_install:append:class-target() {
    rm -r ${D}${sysconfdir}/ssl/
    rm -r ${D}${libdir}/ssl-3/
}
