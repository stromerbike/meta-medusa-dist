SUMMARY = "Specific udev rules for systemd"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r0"

SRC_URI += " \
            file://50-gsm.rules \
            file://50-sda.rules \
            file://50-tty.rules \
"

FILES_${PN}_append = " \
    ${sysconfdir}/udev/rules.d/50-gsm.rules \
    ${sysconfdir}/udev/rules.d/50-sda.rules \
    ${sysconfdir}/udev/rules.d/50-tty.rules \
"

do_install () {
    install -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/50-gsm.rules ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/50-sda.rules ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/50-tty.rules ${D}${sysconfdir}/udev/rules.d/
}
