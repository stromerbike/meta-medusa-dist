SUMMARY = "Specific udev rules for systemd"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PR = "r0"

SRC_URI += " \
            file://50-gsmtty1.rules \
            file://50-sda.rules \
            file://50-ttyacm0.rules \
            file://50-ttymxc.rules \
            file://50-wlan0.rules \
"

FILES_${PN}_append = " \
    ${sysconfdir}/udev/rules.d/ \
"

do_install () {
    install -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/50-gsmtty1.rules ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/50-sda.rules ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/50-ttyacm0.rules ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/50-ttymxc.rules ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/50-wlan0.rules ${D}${sysconfdir}/udev/rules.d/
}
