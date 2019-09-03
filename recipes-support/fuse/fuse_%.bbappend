do_install_append() {
    rm -r ${D}${sysconfdir}/modules-load.d/
}
