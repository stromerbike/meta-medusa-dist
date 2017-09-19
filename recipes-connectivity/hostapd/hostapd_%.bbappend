FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://hostapd.conf \
            file://hostapd.service \
"

#SYSTEMD_AUTO_ENABLE_${PN} = "enable"

do_install_append() {
    install -m 0644 ${WORKDIR}/hostapd.conf ${D}${sysconfdir}/hostapd.conf
}
