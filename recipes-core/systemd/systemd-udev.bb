SUMMARY = "Specific udev rules for systemd"
LICENSE = "CLOSED"

PR = "r0"

SRC_URI += " \
            file://50-tty.rules \
"

FILES_${PN}_append = " \
    ${sysconfdir}/udev/rules.d/50-tty.rules \
"

do_install () {
    install -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/50-tty.rules ${D}${sysconfdir}/udev/rules.d/
}
