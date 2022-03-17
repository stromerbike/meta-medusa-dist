FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://chase_symlinks_etc_localtime.patch \
            file://resolved.conf \
            file://system.conf \
            file://systemd-journal-upload.service.in.patch \
            file://systemd-timesyncd.service.in.patch \
            file://systemd-timesyncd_write_synchronized_file.patch \
            file://timesyncd.conf \
            file://time-sync-wait_service_with_watchfile.patch \
"

# backported from poky commit d0b2cedfb0996739c79a1011159b4047988851bf
SUMMARY_${PN}-journal-upload = "Send journal messages over the network"
DESCRIPTION_${PN}-journal-upload = "systemd-journal-upload uploads journal entries to a specified URL."
PACKAGES =+ " \
    ${PN}-journal-upload \
"
SYSTEMD_PACKAGES += "${@bb.utils.contains('PACKAGECONFIG', 'journal-upload', '${PN}-journal-upload', '', d)}"
FILES_${PN}-journal-upload = "${rootlibexecdir}/systemd/systemd-journal-upload \
                              ${systemd_system_unitdir}/systemd-journal-upload.service \
                              ${sysconfdir}/systemd/journal-upload.conf \
                             "

PACKAGECONFIG_append = " \
    journal-upload \
"

RDEPENDS_${PN} += "systemd-udev systemd-units"

RRECOMMENDS_${PN}_remove = " systemd-extra-utils systemd-compat-units udev-hwdb util-linux-fsck e2fsprogs-e2fsck"

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
    smack \
    sysusers \
    utmp \
    vconsole \
    xz \
"

PACKAGECONFIG[bashcompletion] = ",-Dbashcompletiondir=no,"
PACKAGECONFIG[hwdb] = "-Dhwdb=true,-Dhwdb=false,hwdb"

do_install_append() {
    install -m 0644 ${WORKDIR}/resolved.conf ${D}${sysconfdir}/systemd
    install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd
    install -m 0644 ${WORKDIR}/timesyncd.conf ${D}${sysconfdir}/systemd

    # disable virtual console service
    rm ${D}${sysconfdir}/systemd/system/getty.target.wants/getty@tty1.service

    # remove unused mounts
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/sys-kernel-config.mount
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/sys-kernel-debug.mount

    # disable journal catalog update (/var/lib/systemd/catalog/database is read-only)
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-journal-catalog-update.service
    rm ${D}${nonarch_libdir}/systemd/catalog/systemd.*.catalog

    # disable journal flushing (since we do it ourselves)
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-journal-flush.service

    # disable time wait sync service (since we start it ourselves)
    rm ${D}${sysconfdir}/systemd/system/sysinit.target.wants/systemd-time-wait-sync.service

    # disable update done service
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-update-done.service

    # disable user sessions service
    rm ${D}${systemd_system_unitdir}/multi-user.target.wants/systemd-user-sessions.service

    # remove udev rules for groups which do not exist to avoid errors
    sed -i -e '/GROUP=\"kvm\"/d' ${D}/${base_libdir}/udev/rules.d/50-udev-default.rules
    sed -i -e '/GROUP=\"render\"/d' ${D}/${base_libdir}/udev/rules.d/50-udev-default.rules

    # use fixed machine-id
    echo "1234567890abcdef1234567890abcdef" | tee ${D}${sysconfdir}/machine-id
    rm ${D}${base_bindir}/systemd-machine-id-setup
    rm ${D}${systemd_system_unitdir}/systemd-machine-id-commit.service
    rm ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-machine-id-commit.service

    # use recommended mode of operation for resolved
    rm ${D}${sysconfdir}/resolv-conf.systemd
    ln -s ../run/systemd/resolve/stub-resolv.conf ${D}${sysconfdir}/resolv-conf.systemd

    # start resolved and timesyncd service after check.target
    install -d ${D}${sysconfdir}/systemd/system/communication.target.wants
    mv ${D}${sysconfdir}/systemd/system/sysinit.target.wants/systemd-timesyncd.service ${D}${sysconfdir}/systemd/system/communication.target.wants/systemd-timesyncd.service

    # allow journal to fill up log partition almost to its maximum
    sed -i -e 's/.*SystemMaxUse.*/SystemMaxUse=40M/' ${D}${sysconfdir}/systemd/journald.conf
    sed -i -e 's/.*SystemKeepFree.*/SystemKeepFree=1M/' ${D}${sysconfdir}/systemd/journald.conf

    # do not setup /var/log/journal and /var/spool since the file system is normally read-only
    sed -i -e 's#.*ExecStart.*#& --exclude-prefix=/var/log/journal --exclude-prefix=/var/spool#' ${D}${systemd_system_unitdir}/systemd-tmpfiles-setup.service
    install -m 0644 ${WORKDIR}/systemd-udev-trigger.service ${D}${systemd_system_unitdir}/

    sed -i -e '/After=swap.target/d' ${D}${systemd_system_unitdir}/tmp.mount
    sed -i -e 's/swap.target//' ${D}${systemd_system_unitdir}/sysinit.target

    # Remove unussed generators
    rm ${D}${systemd_unitdir}/system-generators/systemd-debug-generator
    rm ${D}${systemd_unitdir}/system-generators/systemd-gpt-auto-generator
    rm ${D}${systemd_unitdir}/system-generators/systemd-rc-local-generator
    rm ${D}${systemd_unitdir}/system-generators/systemd-system-update-generator
    rm ${D}${systemd_unitdir}/system-generators/systemd-sysv-generator
}
