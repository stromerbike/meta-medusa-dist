FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://0001-chase-symlinks-etc-localtime.patch \
            file://0001-journal-file-disable-sequence-number-ID-check.patch \
            file://0001-journal-file-disable-strict-ordering-by-clock.patch \
            file://0001-move-clock-state-file-to-data-partition.patch \
            file://0001-systemd-journal-upload.service.in.patch \
            file://0001-systemd-resolved.service.in.patch \
            file://0001-systemd-timesyncd.service.in.patch \
            file://0001-systemd-udev-trigger.service.patch \
            file://resolved.conf \
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
    sysusers \
    userdb \
    utmp \
    vconsole \
    wheel-group \
    zstd \
"

PACKAGECONFIG[bashcompletion] = ",-Dbashcompletiondir=no,"
PACKAGECONFIG[hwdb] = "-Dhwdb=true,-Dhwdb=false,hwdb"

do_install:prepend() {
    # create /var/log/journal, since -Dcreate-log-dirs=false is used
    install -d ${D}${localstatedir}/log/journal
}

do_install:append() {
    install -m 0644 ${WORKDIR}/resolved.conf ${D}${sysconfdir}/systemd
    install -m 0644 ${WORKDIR}/timesyncd.conf ${D}${sysconfdir}/systemd

    # disable virtual console service
    sed -i 's/enable getty@.service/disable getty@.service/g' ${D}${systemd_unitdir}/system-preset/90-systemd.preset

    # remove unused mounts
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/sys-fs-fuse-connections.mount
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/sys-kernel-config.mount
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/sys-kernel-debug.mount

    # disable journal catalog update (/var/lib/systemd/catalog/database is read-only)
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-journal-catalog-update.service
    rm ${D}${nonarch_libdir}/systemd/catalog/systemd.*.catalog

    # disable journal flushing (since we do it ourselves)
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-journal-flush.service

    # disable update done service
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-update-done.service

    # remove udev rules for groups which do not exist to avoid errors
    sed -i '/GROUP=\"kvm\"/d' ${D}/${base_libdir}/udev/rules.d/50-udev-default.rules
    sed -i '/GROUP=\"render\"/d' ${D}/${base_libdir}/udev/rules.d/50-udev-default.rules

    # remove machine-id related services since a fixed one is used
    rm ${D}${base_bindir}/systemd-machine-id-setup
    rm ${D}${systemd_system_unitdir}/systemd-machine-id-commit.service
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-machine-id-commit.service

    # disable Predictable Network Interface Names
    rm ${D}${systemd_unitdir}/network/99-default.link

    # use recommended mode of operation for resolved
    rm ${D}${sysconfdir}/resolv-conf.systemd
    ln -s ../run/systemd/resolve/stub-resolv.conf ${D}${sysconfdir}/resolv-conf.systemd

    # allow journal to fill up log partition almost to its maximum
    sed -i 's/.*SystemMaxUse.*/SystemMaxUse=40M/' ${D}${sysconfdir}/systemd/journald.conf
    sed -i 's/.*SystemKeepFree.*/SystemKeepFree=1M/' ${D}${sysconfdir}/systemd/journald.conf

    # do not setup certain tmpfiles:
    # /var/log/journal since we manage it ourselves via mnt-log.service
    # /var/log/private and /var/spool since the file system is normally read-only
    sed -i 's#.*ExecStart.*#& --exclude-prefix=/var/log/journal --exclude-prefix=/var/log/private --exclude-prefix=/var/spool#' ${D}${systemd_system_unitdir}/systemd-tmpfiles-setup.service

    # do not setup tmpfiles for systemd.system-credentials since file system is normally read-only
    rm ${D}/${libdir}/tmpfiles.d/provision.conf

    # disable swap.target
    sed -i '/After=swap.target/d' ${D}${systemd_system_unitdir}/tmp.mount
    sed -i 's/swap.target//' ${D}${systemd_system_unitdir}/sysinit.target

    # remove unused generators
    rm ${D}${systemd_unitdir}/system-generators/systemd-debug-generator
    rm ${D}${systemd_unitdir}/system-generators/systemd-gpt-auto-generator
    rm ${D}${systemd_unitdir}/system-generators/systemd-system-update-generator
}
