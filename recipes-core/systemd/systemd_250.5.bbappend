FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://chase_symlinks_etc_localtime.patch \
            file://introduce-wait-online@.service-for-specific-interface.patch \
            file://move_state_file_to_data_partition.patch \
            file://resolved.conf \
            file://systemd-journal-upload.service.in.patch \
            file://systemd-resolved.service.in.patch \
            file://systemd-timesyncd.service.in.patch \
            file://systemd-udev-trigger.service.patch \
            file://timesyncd.conf \
"

RDEPENDS:${PN} += "systemd-udev systemd-units"

RRECOMMENDS:${PN}:remove = " systemd-extra-utils udev-hwdb util-linux-fsck e2fsprogs-e2fsck"

PACKAGECONFIG:remove = " \
    backlight \
    binfmt \
    gshadow \
    hibernate \
    idn \
    ima \
    localed \
    logind \
    machined \
    myhostname \
    nss \
    nss-mymachines \
    nss-resolve \
    quotacheck \
    randomseed \
    smack \
    sysusers \
    sysvinit \
    userdb \
    utmp \
    vconsole \
    wheel-group \
    zstd \
"

PACKAGECONFIG[bashcompletion] = ",-Dbashcompletiondir=no,"
PACKAGECONFIG[hwdb] = "-Dhwdb=true,-Dhwdb=false,hwdb"

do_install:append() {
    install -m 0644 ${WORKDIR}/resolved.conf ${D}${sysconfdir}/systemd
    install -m 0644 ${WORKDIR}/timesyncd.conf ${D}${sysconfdir}/systemd

    # disable virtual console service
    sed -i 's/enable getty@.service/disable getty@.service/g' ${D}${systemd_unitdir}/system-preset/90-systemd.preset

    # remove unused mounts
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/sys-kernel-config.mount
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/sys-kernel-debug.mount

    # disable journal catalog update (/var/lib/systemd/catalog/database is read-only)
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-journal-catalog-update.service
    rm ${D}${nonarch_libdir}/systemd/catalog/systemd.*.catalog

    # disable journal flushing (since we do it ourselves)
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-journal-flush.service

    # disable update done service
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-update-done.service

    # disable user sessions service
    rm ${D}${systemd_system_unitdir}/multi-user.target.wants/systemd-user-sessions.service

    # remove udev rules for groups which do not exist to avoid errors
    sed -i '/GROUP=\"kvm\"/d' ${D}/${base_libdir}/udev/rules.d/50-udev-default.rules
    sed -i '/GROUP=\"render\"/d' ${D}/${base_libdir}/udev/rules.d/50-udev-default.rules

    # remove machine-id related services since a fixed one is used
    rm ${D}${base_bindir}/systemd-machine-id-setup
    rm ${D}${systemd_system_unitdir}/systemd-machine-id-commit.service
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-machine-id-commit.service

    # use recommended mode of operation for resolved
    rm ${D}${sysconfdir}/resolv-conf.systemd
    ln -s ../run/systemd/resolve/stub-resolv.conf ${D}${sysconfdir}/resolv-conf.systemd

    # allow journal to fill up log partition almost to its maximum
    sed -i 's/.*SystemMaxUse.*/SystemMaxUse=40M/' ${D}${sysconfdir}/systemd/journald.conf
    sed -i 's/.*SystemKeepFree.*/SystemKeepFree=1M/' ${D}${sysconfdir}/systemd/journald.conf

    # do not setup /var/log/journal and /var/spool since the file system is normally read-only
    sed -i 's#.*ExecStart.*#& --exclude-prefix=/var/log/journal --exclude-prefix=/var/spool#' ${D}${systemd_system_unitdir}/systemd-tmpfiles-setup.service

    # disable swap.target
    sed -i '/After=swap.target/d' ${D}${systemd_system_unitdir}/tmp.mount
    sed -i 's/swap.target//' ${D}${systemd_system_unitdir}/sysinit.target

    # remove unused generators
    rm ${D}${systemd_unitdir}/system-generators/systemd-debug-generator
    rm ${D}${systemd_unitdir}/system-generators/systemd-gpt-auto-generator
    rm ${D}${systemd_unitdir}/system-generators/systemd-system-update-generator
}
