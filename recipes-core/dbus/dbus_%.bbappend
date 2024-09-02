FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://0001-dbus.service.in.patch \
"

do_install:append:class-target() {
    rm ${D}${systemd_system_unitdir}/multi-user.target.wants/dbus.service
}
