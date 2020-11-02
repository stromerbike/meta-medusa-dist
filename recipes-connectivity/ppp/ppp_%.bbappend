FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RDEPENDS_${PN} += "dash iproute2"

SRC_URI += " \
            file://script \
"

do_install_append() {
    install -m 0755 ${WORKDIR}/script ${D}${sysconfdir}/ppp/ip-up.d/

    echo "debug" >> ${D}${sysconfdir}/ppp/options
    echo "ipv6cp-use-ipaddr" >> ${D}${sysconfdir}/ppp/options
    echo "mru 1460" >> ${D}${sysconfdir}/ppp/options
    echo "mtu 1460" >> ${D}${sysconfdir}/ppp/options

    echo "nodefaultroute" >> ${D}${sysconfdir}/ppp/options.gsmtty1
    echo "nodefaultroute" >> ${D}${sysconfdir}/ppp/options.ttyACM0
    echo "nodefaultroute" >> ${D}${sysconfdir}/ppp/options.ttyACM1
}
