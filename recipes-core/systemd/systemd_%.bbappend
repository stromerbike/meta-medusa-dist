FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://eth0.network \
            file://eth1.network \
            file://system.conf \
"

PACKAGECONFIG_append = " networkd"

SYSTEMD_DEFAULT_TARGET = "graphical.target"

do_install_append() {
    install -d ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/eth0.network ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/eth1.network ${D}${systemd_unitdir}/network/

    install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd
}
