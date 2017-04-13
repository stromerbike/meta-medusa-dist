FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://system.conf \
"

RDEPENDS_${PN} += "systemd-units"

PACKAGECONFIG_append = " networkd"
PACKAGECONFIG_remove = " xz ldconfig binfmt machined backlight quotacheck hostnamed localed kdbus ima smack logind firstboot utmp polkit"

do_install_append() {
    install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd
}
