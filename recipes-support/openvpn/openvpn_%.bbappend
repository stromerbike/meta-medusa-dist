# Adjust path to avoid " /etc/tmpfiles.d/openvpn.conf:1: Line references path below legacy directory /var/run/, updating /var/run/openvpn → /run/openvpn; please update the tmpfiles.d/ drop-in file accordingly."
# Might become obsolete with https://github.com/openembedded/meta-openembedded/commit/c098cf9190413f237dc49d29c57be2f579fd4c40
do_install:append() {
    sed -i -e 's#${localstatedir}##g' ${D}${sysconfdir}/tmpfiles.d/openvpn.conf
}
