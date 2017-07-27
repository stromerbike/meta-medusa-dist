SUMMARY = "Specific services for systemd"
LICENSE = "CLOSED"

PR = "r0"

# can0 service depends on ip which is included in iproute2
RDEPENDS_${PN} += "bash busybox iproute2"

SRC_URI += " \
            file://can0.service \
            file://ble.service \
            file://ble.sh \
            file://eth0.network \
            file://eth1.network \
            file://gsm.service \
            file://gsm.sh \
            file://led.service \
            file://led.sh \
            file://mnt-data.service \
            file://mnt-data.sh \
            file://mnt-rfs.service \
            file://mnt-rfs.sh \
            file://pwr.service \
            file://pwr.sh \
            file://usb.service \
            file://usb.sh \
"

FILES_${PN}_append = " \
    /mnt/* \
    ${systemd_system_unitdir} \
    ${systemd_unitdir}/network/ \
    ${sysconfdir}/scripts/ \
"

inherit systemd

NATIVE_SYSTEMD_SUPPORT = "1"

SYSTEMD_SERVICE_${PN} = " \
    ble.service \
    can0.service \
    gsm.service \
    led.service \
    mnt-data.service \
    mnt-rfs.service \
    pwr.service \
    usb.service \
"

do_install_append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/can0.service ${D}/${systemd_system_unitdir}

    install -d ${D}${sysconfdir}/scripts
    install -m 0644 ${WORKDIR}/ble.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/ble.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/gsm.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/gsm.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/led.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/led.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/pwr.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/pwr.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/usb.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/usb.sh ${D}${sysconfdir}/scripts/

    install -d ${D}/mnt/ubi2
    install -d ${D}/mnt/ubi3
    install -d ${D}/mnt/data
    install -m 0644 ${WORKDIR}/mnt-data.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/mnt-data.sh ${D}${sysconfdir}/scripts/

    install -d ${D}/mnt/rfs_inactive
    install -m 0644 ${WORKDIR}/mnt-rfs.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/mnt-rfs.sh ${D}${sysconfdir}/scripts/

    install -d ${D}${systemd_unitdir}/network
    install -m 0644 ${WORKDIR}/eth0.network ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/eth1.network ${D}${systemd_unitdir}/network/
}
