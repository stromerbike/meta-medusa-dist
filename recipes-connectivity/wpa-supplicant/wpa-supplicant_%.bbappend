PACKAGECONFIG:remove = " gnutls"

PACKAGECONFIG:append = " openssl"

do_install:append() {
    sed -i 's#Type=simple#Type=simple\nExecStartPre=/bin/sleep 10#' ${D}${systemd_system_unitdir}/wpa_supplicant@.service
    sed -i 's#/etc/wpa_supplicant/wpa_supplicant-%I.conf#/mnt/usb/wlan/wpa_supplicant.conf#' ${D}${systemd_system_unitdir}/wpa_supplicant@.service
}

RRECOMMENDS:${PN}:remove = "${PN}-passphrase ${PN}-cli ${PN}-plugins"
