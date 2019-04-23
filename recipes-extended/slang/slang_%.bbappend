do_install_append() {
    rm -r ${D}${libdir}/${BPN}/
    rm -r ${D}${datadir}/slsh/
}
