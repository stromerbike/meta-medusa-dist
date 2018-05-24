FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI = " \
           file://gpsd-machine \
"

inherit update-alternatives

ALTERNATIVE_${PN} = "gpsd-defaults"
ALTERNATIVE_LINK_NAME[gpsd-defaults] = "${sysconfdir}/default/gpsd"
ALTERNATIVE_TARGET[gpsd-defaults] = "${sysconfdir}/default/gpsd.machine"
ALTERNATIVE_PRIORITY[gpsd-defaults] = "15"

do_install() {
    install -d ${D}/${sysconfdir}/default
    install -m 0644 ${WORKDIR}/gpsd-machine ${D}/${sysconfdir}/default/gpsd.machine
}
