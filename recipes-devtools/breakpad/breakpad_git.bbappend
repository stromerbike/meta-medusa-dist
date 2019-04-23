RDEPENDS_${PN}-dev += "${PN}-staticdev"

EXTRA_OECONF_append_class-target += "--disable-tools"

do_install_append_class-target() {
    rm ${D}${bindir}/microdump_stackwalk
    rm ${D}${bindir}/minidump_dump
}
