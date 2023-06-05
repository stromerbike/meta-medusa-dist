PACKAGECONFIG:remove = " gnutls"

PACKAGECONFIG:append = " openssl"

SYSTEMD_SERVICE:${PN} += "wpa_supplicant-wext@.service"

do_install:append() {
    cp ${D}${systemd_system_unitdir}/wpa_supplicant-nl80211@.service ${D}${systemd_system_unitdir}/wpa_supplicant-wext@.service
    sed -i 's/nl80211/wext/' ${D}${systemd_system_unitdir}/wpa_supplicant-wext@.service
    sed -i 's/-Dnl80211/-Dwext/' ${D}${systemd_system_unitdir}/wpa_supplicant-wext@.service
    sed -i 's#/etc/wpa_supplicant/wpa_supplicant-wext-%I.conf#/mnt/usb/wlan/wpa_supplicant.conf#' ${D}${systemd_system_unitdir}/wpa_supplicant-wext@.service
    sed -i 's#Type=simple#Type=simple\nExecStartPre=/bin/sleep 10#' ${D}${systemd_system_unitdir}/wpa_supplicant-wext@.service
}
