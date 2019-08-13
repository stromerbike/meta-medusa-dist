do_install_append_class-target() {
    find ${D}${libdir}/${BPN}/ -type f,l -not -name '*arm*' -delete
}
