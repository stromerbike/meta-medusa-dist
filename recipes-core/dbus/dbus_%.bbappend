FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://dbus.service.in.patch \
"

do_install_append_class-target() {
    rm ${D}${systemd_system_unitdir}/multi-user.target.wants/dbus.service
}
