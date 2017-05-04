SUMMARY = "Specific services for systemd"
LICENSE = "CLOSED"

PR = "r0"

RDEPENDS_${PN} += "bash wvdial"

SRC_URI += " \
            file://can0.service \
            file://eth0.network \
            file://eth1.network \
            file://power.service \
            file://power.sh \
            file://wvdial.service \
"

FILES_${PN}_append = " \
    ${systemd_system_unitdir} \
    ${systemd_unitdir}/network/ \
    ${sysconfdir}/scripts/ \
"

inherit systemd

NATIVE_SYSTEMD_SUPPORT = "1"

SYSTEMD_SERVICE_${PN} = " \
    can0.service \
    power.service \
    wvdial.service \
"

do_install_append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/can0.service ${D}/${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/wvdial.service ${D}/${systemd_system_unitdir}
    
    install -d ${D}${sysconfdir}/scripts
    install -m 0644 ${WORKDIR}/power.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/power.sh ${D}${sysconfdir}/scripts/power.sh

    install -d ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/eth0.network ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/eth1.network ${D}${systemd_unitdir}/network/
}
