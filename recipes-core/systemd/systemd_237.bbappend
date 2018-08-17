FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://chase_symlinks_etc_localtime.patch \
            file://system.conf \
            file://systemd-timesyncd.service.in.patch \
            file://timesyncd.conf \
"

RDEPENDS_${PN} += "systemd-udev systemd-units"

RRECOMMENDS_${PN}_remove = " systemd-extra-utils systemd-compat-units udev-hwdb util-linux-fsck e2fsprogs-e2fsck kernel-module-autofs4 kernel-module-ipv6"

PACKAGECONFIG_remove = " \
    backlight \
    binfmt \
    firstboot \
    hibernate \
    ima \
    localed \
    logind \
    machined \
    myhostname \
    nss \
    polkit \
    quotacheck \
    randomseed \
    resolved \
    smack \
    sysusers \
    utmp \
    vconsole \
    xz \
"

PACKAGECONFIG[hwdb] = "-Dhwdb=true,-Dhwdb=false,hwdb"

do_install_append() {
    install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd
    install -m 0644 ${WORKDIR}/timesyncd.conf ${D}${sysconfdir}/systemd

    # disable virtual console service
    rm ${D}${sysconfdir}/systemd/system/getty.target.wants/getty@tty1.service

    # remove unused mounts
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/sys-kernel-config.mount
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/sys-kernel-debug.mount

    # disable journal catalog update (/var/lib/systemd/catalog/database is read-only)
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-journal-catalog-update.service

    # disable journal flushing (since we do it ourselves)
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-journal-flush.service

    # disable update done service
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-update-done.service

    # disable user sessions service
    rm ${D}${systemd_system_unitdir}/multi-user.target.wants/systemd-user-sessions.service

    # use fixed machine-id
    echo "1234567890abcdef1234567890abcdef" | tee ${D}${sysconfdir}/machine-id
    rm ${D}${base_bindir}/systemd-machine-id-setup
    rm ${D}${systemd_system_unitdir}/systemd-machine-id-commit.service
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-machine-id-commit.service

    # start timesyncd service after drive.target
    install -d ${D}${sysconfdir}/systemd/system/communication.target.wants
    mv ${D}${sysconfdir}/systemd/system/sysinit.target.wants/systemd-timesyncd.service ${D}${sysconfdir}/systemd/system/communication.target.wants/systemd-timesyncd.service

    # allow journal to fill up log partition almost to its maximum
    sed -i -e 's/.*SystemMaxUse.*/SystemMaxUse=40M/' ${D}${sysconfdir}/systemd/journald.conf
    sed -i -e 's/.*SystemKeepFree.*/SystemKeepFree=1M/' ${D}${sysconfdir}/systemd/journald.conf

    # do not setup /var/log/journal as it is write protected
    sed -i -e 's#.*ExecStart.*#& --exclude-prefix=/var/log/journal#' ${D}${systemd_system_unitdir}/systemd-tmpfiles-setup.service
}
