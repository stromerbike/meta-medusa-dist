do_install_append_class-target() {
    sed -i 's/Requires=dbus.socket/Requires=dbus.socket\nAfter=drive.target/' ${D}${systemd_system_unitdir}/dbus.service
    rm ${D}${systemd_system_unitdir}/multi-user.target.wants/dbus.service
}
