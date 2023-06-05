FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://99_init_strings.patch \
            file://init_modem_skippable_commands.patch \
            file://wvdial.conf \
"

do_install:append() {
    install -m 0644 ${WORKDIR}/wvdial.conf ${D}/${sysconfdir}
}
