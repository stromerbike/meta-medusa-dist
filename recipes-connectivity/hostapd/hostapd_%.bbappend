FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://hostapd.service \
"

do_install:append() {
    sed -i 's/^#country_code=.*/country_code=CH/' ${D}${sysconfdir}/hostapd.conf
    sed -i 's/^#wpa=.*/wpa=2/' ${D}${sysconfdir}/hostapd.conf
    sed -i 's/^#wpa_passphrase=.*/wpa_passphrase=12345678/' ${D}${sysconfdir}/hostapd.conf
    sed -i 's/^#wpa_key_mgmt=.*/wpa_key_mgmt=WPA-PSK/' ${D}${sysconfdir}/hostapd.conf
    sed -i 's/^#wpa_pairwise=.*/wpa_pairwise=TKIP/' ${D}${sysconfdir}/hostapd.conf
    sed -i 's/^#rsn_pairwise=.*/rsn_pairwise=CCMP/' ${D}${sysconfdir}/hostapd.conf
}
