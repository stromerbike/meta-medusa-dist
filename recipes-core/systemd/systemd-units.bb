SUMMARY = "Specific services for systemd"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r0"

# can0 service depends on ip which is included in iproute2
RDEPENDS_${PN} += "bash busybox e2fsprogs-mke2fs evtest fbida iproute2 mtd-utils ppp rsync wvdial"

SRC_URI += " \
            file://images/busy.png \
            file://images/done.png \
            file://images/error.png \
            file://images/logo.png \
            file://ble.service \
            file://ble.sh \
            file://bmp280.service \
            file://can0.service \
            file://communication.target \
            file://debug.target \
            file://drive.target \
            file://eth0.network \
            file://eth1.network \
            file://fwu-inc-pre.service \
            file://fwu-inc-pre.sh \
            file://fwu-usb.service \
            file://fwu-usb.sh \
            file://gsm.service \
            file://gsm.sh \
            file://led.service \
            file://led.sh \
            file://mnt-data.service \
            file://mnt-data.sh \
            file://mnt-rfs.service \
            file://mnt-rfs.sh \
            file://pwr-io.service \
            file://pwr-io.sh \
            file://pwr-sup.service \
            file://pwr-sup.sh \
            file://usb.service \
            file://usb.sh \
            file://wvdial.service \
            file://wvdial-swisscom.service \
            file://zram.service \
            file://zram.sh \
"

FILES_${PN}_append = " \
    /mnt/ \
    ${systemd_system_unitdir} \
    ${systemd_unitdir}/network/ \
    ${sysconfdir}/images/ \
    ${sysconfdir}/scripts/ \
"

inherit systemd

NATIVE_SYSTEMD_SUPPORT = "1"

SYSTEMD_SERVICE_${PN} = " \
    ble.service \
    bmp280.service \
    can0.service \
    gsm.service \
    led.service \
    mnt-data.service \
    pwr-io.service \
    pwr-sup.service \
    usb.service \
    wvdial.service \
"

do_install_append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/can0.service ${D}${systemd_system_unitdir}

    install -d ${D}${sysconfdir}/scripts
    install -m 0644 ${WORKDIR}/ble.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/ble.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/bmp280.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/gsm.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/gsm.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/led.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/led.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/pwr-io.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/pwr-io.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/pwr-sup.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/pwr-sup.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/usb.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/usb.sh ${D}${sysconfdir}/scripts/

    install -d ${D}/mnt/ubi2
    install -d ${D}/mnt/ubi3
    install -d ${D}/mnt/data
    install -d ${D}/mnt/data_backup
    install -m 0644 ${WORKDIR}/mnt-data.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/mnt-data.sh ${D}${sysconfdir}/scripts/

    install -d ${D}/mnt/rfs_inactive
    install -m 0644 ${WORKDIR}/mnt-rfs.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/mnt-rfs.sh ${D}${sysconfdir}/scripts/

    install -d ${D}/mnt/zram
    install -m 0644 ${WORKDIR}/zram.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/zram.sh ${D}${sysconfdir}/scripts/

    install -m 0644 ${WORKDIR}/fwu-inc-pre.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/fwu-inc-pre.sh ${D}${sysconfdir}/scripts/

    install -m 0644 ${WORKDIR}/fwu-usb.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/fwu-usb.sh ${D}${sysconfdir}/scripts/

    install -d ${D}${sysconfdir}/images
    install -m 0644 ${WORKDIR}/images/busy.png ${D}${sysconfdir}/images/
    install -m 0644 ${WORKDIR}/images/done.png ${D}${sysconfdir}/images/
    install -m 0644 ${WORKDIR}/images/error.png ${D}${sysconfdir}/images/
    install -m 0644 ${WORKDIR}/images/logo.png ${D}${sysconfdir}/images/

    install -d ${D}${systemd_unitdir}/network
    install -m 0644 ${WORKDIR}/eth0.network ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/eth1.network ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/wvdial.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/wvdial-swisscom.service ${D}${systemd_system_unitdir}

    install -m 0644 ${WORKDIR}/communication.target ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/debug.target ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/drive.target ${D}${systemd_system_unitdir}
}
