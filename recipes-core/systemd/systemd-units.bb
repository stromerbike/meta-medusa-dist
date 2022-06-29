SUMMARY = "Specific services for systemd"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PR = "r0"

# can0 service depends on ip which is included in iproute2
RDEPENDS_${PN} += " \
    bash \
    bluez5 \
    busybox \
    can-utils \
    cpupower \
    dash \
    evtest \
    fbv \
    gnupg-gpgv \
    iproute2 \
    inotify-tools \
    medusa-scripts \
    multilog \
    picocom \
    ppp \
    pv \
    systemd (>= 236) \
    tar \
    usbutils \
    util-linux-ldattach \
    wvdial \
    x11vnc \
    xz \
    zip \
"

SRC_URI += " \
            file://images/busy.png \
            file://images/done.png \
            file://images/error.png \
            file://images/logo.png \
            file://ble-attach.service \
            file://ble-attach.sh \
            file://ble.target \
            file://btmon-save@.service \
            file://btmon-save.sh \
            file://btmon.service \
            file://bnep0.network \
            file://can0.service \
            file://can0.sh \
            file://candump-save@.service \
            file://candump-save.sh \
            file://candump.service \
            file://candump.awk \
            file://check.target \
            file://gsm.target \
            file://cpupower.service \
            file://debug.target \
            file://drive.target \
            file://eth0.network \
            file://fwu-usb-chk.service \
            file://fwu-usb-chk.sh \
            file://fwu-usb-run.service \
            file://fwu-usb-run.sh \
            file://gps.target \
            file://gsm.service \
            file://gsm.sh \
            file://hostname-det.service \
            file://hostname-det.sh \
            file://hostname-set.service \
            file://late-init.target \
            file://ldattach-hl78xx.service \
            file://ldattach-hl78xx.sh \
            file://led.service \
            file://led.sh \
            file://log-usb.service \
            file://log-usb.sh \
            file://mnt-data.mount \
            file://mnt-log.service \
            file://mnt-rfs.service \
            file://mnt-rfs.sh \
            file://mnt-usb.service \
            file://mnt-usb.sh \
            file://peripheral-mpio.service \
            file://peripheral-mpio.sh \
            file://peripheral-pwr.service \
            file://peripheral-pwr.sh \
            file://peripheral-stem.service \
            file://peripheral-stem.sh \
            file://systemd-udev-early-trigger.service \
            file://started.target \
            file://usb.service \
            file://usb.sh \
            file://vnc-server.service \
            file://wlan0-ap.network \
            file://wlan0.network \
            file://wlan0.sh \
            file://wvdial-hl78xx-usb.service \
            file://wvdial-hl78xx.service \
            file://wvdial.service \
            file://wvdial.sh \
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
    ${@oe.utils.ifelse(d.getVar('DISTRO_VERSION', True).endswith('-EMV'), '', 'ble-attach.service')} \
    ${@oe.utils.ifelse(d.getVar('DISTRO_VERSION', True).endswith('-EMV'), '', 'btmon.service')} \
    can0.service \
    candump.service \
    cpupower.service \
    ${@oe.utils.ifelse(d.getVar('DISTRO_VERSION', True).endswith('-EMV'), '', 'gsm.service')} \
    hostname-det.service \
    hostname-set.service \
    led.service \
    mnt-data.mount \
    mnt-log.service \
    peripheral-mpio.service \
    peripheral-pwr.service \
    usb.service \
    vnc-server.service \
"

do_install_append() {
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
    install -m 0644 ${WORKDIR}/cpupower.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/gsm.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/gsm.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/hostname-det.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/hostname-det.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/hostname-set.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/ldattach-hl78xx.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/ldattach-hl78xx.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/led.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/led.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/peripheral-mpio.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/peripheral-mpio.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/peripheral-pwr.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/peripheral-pwr.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/peripheral-stem.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/peripheral-stem.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/systemd-udev-early-trigger.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/usb.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/usb.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/vnc-server.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/wlan0.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/wvdial-hl78xx-usb.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/wvdial-hl78xx.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/wvdial.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/wvdial.sh ${D}${sysconfdir}/scripts/

    install -d ${D}/mnt/ubi2
    install -d ${D}/mnt/ubi3
    install -d ${D}/mnt/data
    install -d ${D}/mnt/log
    install -m 0644 ${WORKDIR}/mnt-data.mount ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/mnt-log.service ${D}${systemd_system_unitdir}

    install -d ${D}/mnt/rfs_inactive
    install -m 0644 ${WORKDIR}/mnt-rfs.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/mnt-rfs.sh ${D}${sysconfdir}/scripts/

    install -d ${D}/mnt/usb
    install -m 0644 ${WORKDIR}/mnt-usb.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/mnt-usb.sh ${D}${sysconfdir}/scripts/

    install -m 0644 ${WORKDIR}/fwu-usb-chk.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/fwu-usb-chk.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/fwu-usb-run.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/fwu-usb-run.sh ${D}${sysconfdir}/scripts/
    install -m 0644 ${WORKDIR}/log-usb.service ${D}${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/log-usb.sh ${D}${sysconfdir}/scripts/

    install -d ${D}${sysconfdir}/images
    install -m 0644 ${WORKDIR}/images/busy.png ${D}${sysconfdir}/images/
    install -m 0644 ${WORKDIR}/images/done.png ${D}${sysconfdir}/images/
    install -m 0644 ${WORKDIR}/images/error.png ${D}${sysconfdir}/images/
    install -m 0644 ${WORKDIR}/images/logo.png ${D}${sysconfdir}/images/

    install -d ${D}${systemd_unitdir}/network
    install -m 0644 ${WORKDIR}/bnep0.network ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/eth0.network ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/wlan0-ap.network ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/wlan0.network ${D}${systemd_unitdir}/network/

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
