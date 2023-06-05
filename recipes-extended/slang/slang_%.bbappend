do_install:append() {
    rm -r ${D}${libdir}/${BPN}/
    rm -r ${D}${datadir}/slsh/
}
