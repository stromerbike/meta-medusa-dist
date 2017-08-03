FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://chatscripts/stromer \
            file://peers/stromer \
"

do_install_append() {
    install -m 0755 ${WORKDIR}/chatscripts/stromer ${D}${sysconfdir}/chatscripts
    install -m 0755 ${WORKDIR}/peers/stromer ${D}${sysconfdir}/ppp/peers/stromer
}
