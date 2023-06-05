RDEPENDS:${PN}-dev += "${PN}-staticdev"

EXTRA_OECONF:append:class-target = " --disable-tools"

do_install:append:class-target() {
    rm ${D}${bindir}/microdump_stackwalk
    rm ${D}${bindir}/minidump_dump
}
