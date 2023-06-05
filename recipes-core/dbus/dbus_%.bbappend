FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://dbus.service.in.patch \
"

do_install:append:class-target() {
    rm ${D}${systemd_system_unitdir}/multi-user.target.wants/dbus.service
}
