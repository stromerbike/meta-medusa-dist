do_install:append:class-target() {
    # ensure that su is only useable by root
    chmod 4700 ${D}${base_bindir}/su
}
