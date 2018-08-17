do_install_append() {
    sed -i 's/^[#[:space:]]*session optional pam_systemd.so.*/#session optional pam_systemd.so/' ${D}${sysconfdir}/pam.d/common-session
}
