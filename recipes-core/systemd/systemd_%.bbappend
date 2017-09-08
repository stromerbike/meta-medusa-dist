FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://system.conf \
            file://timesyncd.conf \
"

RDEPENDS_${PN} += "systemd-udev systemd-units"

PACKAGECONFIG_append = " networkd"
PACKAGECONFIG_remove = " xz ldconfig binfmt machined backlight quotacheck hostnamed localed kdbus ima smack logind firstboot utmp polkit"

do_install_append() {
    install -m 0644 ${WORKDIR}/system.conf ${D}${systemd_unitdir}
    install -m 0644 ${WORKDIR}/timesyncd.conf ${D}${systemd_unitdir}

    # disable virtual console
    rm ${D}${sysconfdir}/systemd/system/getty.target.wants/getty@tty1.service

    # use fixed machine-id
    echo "1234567890abcdef1234567890abcdef" | tee ${D}${sysconfdir}/machine-id
    rm ${D}${base_bindir}/systemd-machine-id-setup
    rm ${D}${systemd_system_unitdir}/systemd-machine-id-commit.service
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-machine-id-commit.service
}
