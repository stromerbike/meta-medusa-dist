FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RDEPENDS_${PN} += "bash"

SRC_URI += " \
            file://script \
"

do_install_append() {
    install -m 0755 ${WORKDIR}/script ${D}${sysconfdir}/ppp/ip-up.d/

    echo "noccp" >> ${D}${sysconfdir}/ppp/options
    echo "debug" >> ${D}${sysconfdir}/ppp/options
}
