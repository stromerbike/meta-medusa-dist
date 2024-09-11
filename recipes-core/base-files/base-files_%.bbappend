FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append() {
    # To help in cases where the mobile connection is very congested (e. g.
    # when NB-IoT is being used and an FOTA download running), a hosts file
    # that is dynamically populated once after the connection is initially
    # established, provides a method for systemd-resolved (ReadEtcHosts=yes)
    # to look up hosts without the risk of failing due to timeouts.
    # This allows the communication with the backend to focus on delivering
    # payload (without the need to resolve backend.stromer.internal once its
    # TTL would have been expired in the cache of systemd-resolved).
    # Although this approach is not compliant with how the TTL is intended
    # to work and takes some of the D out of DNS, it is considered as
    # worthwhile since it is expected to help with the connectivity to the
    # backend. Moreover, it is rather unrealistic that the IP of the backend
    # will ever change.
    mv ${D}${sysconfdir}/hosts ${D}${sysconfdir}/hosts.static
    ln -s /tmp/hosts ${D}${sysconfdir}/hosts
}
