FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://chase_symlinks_etc_localtime.patch \
            file://system.conf \
            file://timesyncd.conf \
"

RDEPENDS_${PN} += "systemd-udev systemd-units"

RRECOMMENDS_${PN}_remove = " systemd-extra-utils systemd-compat-units udev-hwdb util-linux-fsck e2fsprogs-e2fsck kernel-module-autofs4 kernel-module-ipv6"

PACKAGECONFIG_remove = " xz binfmt randomseed machined backlight vconsole quotacheck hibernate localed ima smack firstboot utmp polkit resolved"

do_install_append() {
    install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd
    install -m 0644 ${WORKDIR}/timesyncd.conf ${D}${sysconfdir}/systemd

    # disable virtual console
    rm ${D}${sysconfdir}/systemd/system/getty.target.wants/getty@tty1.service

    # use fixed machine-id
    echo "1234567890abcdef1234567890abcdef" | tee ${D}${sysconfdir}/machine-id
    rm ${D}${base_bindir}/systemd-machine-id-setup
    rm ${D}${systemd_system_unitdir}/systemd-machine-id-commit.service
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-machine-id-commit.service
    
    # start timesyncd service after drive.target
    sed -i 's/After=systemd-remount-fs.service systemd-tmpfiles-setup.service systemd-sysusers.service/After=systemd-remount-fs.service systemd-tmpfiles-setup.service systemd-sysusers.service drive.target/' ${D}${systemd_system_unitdir}/systemd-timesyncd.service
    sed -i 's/Before=time-sync.target sysinit.target shutdown.target/Before=shutdown.target/' ${D}${systemd_system_unitdir}/systemd-timesyncd.service
    sed -i 's/WantedBy=sysinit.target/WantedBy=communication.target/' ${D}${systemd_system_unitdir}/systemd-timesyncd.service
    install -d ${D}${sysconfdir}/systemd/system/communication.target.wants
    mv ${D}${sysconfdir}/systemd/system/sysinit.target.wants/systemd-timesyncd.service ${D}${sysconfdir}/systemd/system/communication.target.wants/systemd-timesyncd.service
}
