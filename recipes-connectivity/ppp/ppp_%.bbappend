do_install_append() {
    echo "debug" >> ${D}${sysconfdir}/ppp/options
    echo "ipv6cp-use-ipaddr" >> ${D}${sysconfdir}/ppp/options
    echo "mru 1460" >> ${D}${sysconfdir}/ppp/options
    echo "mtu 1460" >> ${D}${sysconfdir}/ppp/options

    # DNS settings in resolved.conf shall be used
    ${D}${sysconfdir}/ppp/ip-up.d/08setupdns
    ${D}${sysconfdir}/ppp/ip-down.d/92removedns
}
