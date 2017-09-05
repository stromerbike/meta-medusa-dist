do_install_append() {
    # enable autologin for root
    sed -i -e 's/^\(ExecStart *=.*getty \)/\1--autologin root /' ${D}${systemd_system_unitdir}/serial-getty@.service
}
