do_install:append() {
    rm -r ${D}${sysconfdir}/modules-load.d/
}
