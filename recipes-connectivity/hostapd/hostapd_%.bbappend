FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://defconfig \
            file://hostapd.conf \
            file://hostapd.service \
"

do_install:append() {
    install -m 0644 ${WORKDIR}/hostapd.conf ${D}${sysconfdir}/hostapd.conf
}
