SUMMARY = "Specific udev rules for systemd"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r0"

RDEPENDS_${PN} += "bash"

SRC_URI += " \
            file://50-huawei-swisscom.rules \
            file://50-ppp1.rules \
            file://50-sda.rules \
            file://50-tty.rules \
            file://ip-route-default-ppp0.sh \
            file://ip-route-default-ppp1.sh \
"

FILES_${PN}_append = " \
    ${sysconfdir}/scripts/ \
    ${sysconfdir}/udev/rules.d/ \
"

do_install () {
    install -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/50-huawei-swisscom.rules ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/50-sda.rules ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/50-tty.rules ${D}${sysconfdir}/udev/rules.d/

    install -d ${D}${sysconfdir}/scripts
    install -m 0644 ${WORKDIR}/50-ppp1.rules ${D}${sysconfdir}/udev/rules.d/
    install -m 0755 ${WORKDIR}/ip-route-default-ppp0.sh ${D}${sysconfdir}/scripts/
    install -m 0755 ${WORKDIR}/ip-route-default-ppp1.sh ${D}${sysconfdir}/scripts/
}
