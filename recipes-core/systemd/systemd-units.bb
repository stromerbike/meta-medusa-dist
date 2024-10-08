SUMMARY = "Specific services for systemd"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PR = "r0"

# candump-save preferably uses the more performant gawk over busybox awk
# CAN netlink support has been added to busybox (iproute2 is thus not required)
RDEPENDS:${PN} += " \
    bash \
    bluez5 \
    busybox \
    can-utils \
    dash \
    evtest \
    fbv \
    gnupg-gpgv \
    inotify-tools \
    lzop \
    medusa-scripts \
    mtd-utils-ubifs-mkfs \
    multilog \
    picocom \
    ppp \
    pv (= 1.6.6) \
    systemd \
    tar \
    usbutils \
    util-linux-ldattach \
    wvdial \
    x11vnc \
    xz \
    zip \
"

RRECOMMENDS:${PN} = "gnuwin-gawk"

SRC_URI += " \
            file://images/busy.png \
            file://images/done.png \
            file://images/error.png \
            file://images/logo.png \
            file://10-bnep0.network \
            file://10-eth0.network \
            file://10-wlan0-ap.network \
            file://10-wlan0.network \
            file://ble-attach.service \
            file://ble-attach.sh \
            file://ble.target \
            file://btmon-save@.service \
            file://btmon-save.sh \
            file://btmon.service \
            file://can0.service \
            file://can0.sh \
            file://candump-save@.service \
            file://candump-save.sh \
            file://candump.service \
            file://candump.awk \
            file://check.target \
            file://chk-usb.service \
            file://chk-usb.sh \
            file://debug.target \
            file://drive.target \
            file://fwu-usb.service \
            file://fwu-usb.sh \
            file://gps.service \
            file://gps.sh \
            file://gps.target \
            file://gsm.service \
            file://gsm.sh \
            file://gsm.target \
            file://hostname-det.service \
            file://hostname-det.sh \
            file://hostname-set.service \
            file://hosts-static.service \
            file://late-init.target \
            file://ldattach-hl78xx.service \
            file://ldattach-hl78xx.sh \
            file://log-usb.service \
            file://log-usb.sh \
            file://mnt-data.mount \
            file://mnt-log.service \
            file://mnt-log.sh \
            file://mnt-rfs.service \
            file://mnt-rfs.sh \
            file://mnt-usb.service \
            file://mnt-usb.sh \
            file://mount.ntfs \
            file://peripheral-mpio.service \
            file://peripheral-mpio.sh \
            file://peripheral-pwr.service \
            file://peripheral-pwr.sh \
            file://peripheral-stem.service \
            file://peripheral-stem.sh \
            file://systemd-timesyncd-prepare.service \
            file://systemd-udev-early-trigger.service \
            file://started.target \
            file://usb.service \
            file://usb.sh \
            file://vnc-server.service \
            file://wlan0.sh \
            file://wvdial-hl78xx-usb.service \
            file://wvdial-hl78xx.service \
            file://wvdial.service \
            file://wvdial.sh \
"

FILES:${PN}:append = " \
    /mnt/ \
    ${base_sbindir}/mount.ntfs \
    ${systemd_system_unitdir} \
    ${systemd_unitdir}/network/ \
    ${sysconfdir}/images/ \
    ${sysconfdir}/scripts/ \
"

inherit systemd

NATIVE_SYSTEMD_SUPPORT = "1"

SYSTEMD_SERVICE:${PN} = " \
    ${@oe.utils.ifelse('-EMV' in d.getVar('DISTRO_VERSION', True), '', 'ble-attach.service')} \
    ${@oe.utils.ifelse('-EMV' in d.getVar('DISTRO_VERSION', True), '', 'btmon.service')} \
    can0.service \
    candump.service \
    ${@oe.utils.ifelse('-EMV' in d.getVar('DISTRO_VERSION', True), '', 'gsm.service')} \
    hostname-det.service \
    hostname-set.service \
    hosts-static.service \
    mnt-data.mount \
    mnt-log.service \
    peripheral-mpio.service \
    peripheral-pwr.service \
    systemd-timesyncd-prepare.service \
    usb.service \
    vnc-server.service \
"

do_install:append() {
    install -d ${D}${systemd_system_unitdir}
    install -d ${D}${sysconfdir}/scripts
    install -m 0644 ${WORKDIR}/ble-attach.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/ble-attach.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/btmon-save@.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/btmon-save.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/btmon.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/can0.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/can0.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/candump-save@.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/candump-save.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/candump.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/candump.awk ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/gps.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/gps.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/gsm.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/gsm.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/hostname-det.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/hostname-det.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/hostname-set.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/hosts-static.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/ldattach-hl78xx.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/ldattach-hl78xx.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/peripheral-mpio.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/peripheral-mpio.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/peripheral-pwr.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/peripheral-pwr.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/peripheral-stem.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/peripheral-stem.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/systemd-timesyncd-prepare.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/systemd-udev-early-trigger.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/usb.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/usb.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/vnc-server.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/wlan0.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/wvdial-hl78xx-usb.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/wvdial-hl78xx.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/wvdial.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/wvdial.sh ${D}${sysconfdir}/scripts/

    install -d ${D}/mnt/data
    install -m 0644 ${WORKDIR}/mnt-data.mount ${D}${systemd_system_unitdir}

    install -d ${D}/mnt/log
    install -m 0644 ${WORKDIR}/mnt-log.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/mnt-log.sh ${D}${sysconfdir}/scripts/

    install -d ${D}/mnt/rfs_inactive
    install -m 0644 ${WORKDIR}/mnt-rfs.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/mnt-rfs.sh ${D}${sysconfdir}/scripts/

    install -d ${D}/mnt/usb
    install -m 0644 ${WORKDIR}/mnt-usb.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/mnt-usb.sh ${D}${sysconfdir}/scripts/
    install -d ${D}${base_sbindir}
    install -m 0755 ${WORKDIR}/mount.ntfs ${D}${base_sbindir}/

    install -m 0644 ${WORKDIR}/chk-usb.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/chk-usb.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/fwu-usb.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/fwu-usb.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/log-usb.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/log-usb.sh ${D}${sysconfdir}/scripts/

    install -d ${D}${sysconfdir}/images
    install -m 0644 ${WORKDIR}/images/busy.png ${D}${sysconfdir}/images/
    install -m 0644 ${WORKDIR}/images/done.png ${D}${sysconfdir}/images/
    install -m 0644 ${WORKDIR}/images/error.png ${D}${sysconfdir}/images/
    install -m 0644 ${WORKDIR}/images/logo.png ${D}${sysconfdir}/images/

    install -d ${D}${systemd_unitdir}/network
    install -m 0644 ${WORKDIR}/10-bnep0.network ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/10-eth0.network ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/10-wlan0-ap.network ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/10-wlan0.network ${D}${systemd_unitdir}/network/

    install -m 0644 ${WORKDIR}/ble.target ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/check.target ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/gsm.target ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/debug.target ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/drive.target ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/gps.target ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/late-init.target ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/started.target ${D}${systemd_system_unitdir}

    if echo "${DISTRO_VERSION}" | grep EMV; then
        sed -i '/504/d' ${D}${sysconfdir}/scripts/usb.sh
    fi
}
