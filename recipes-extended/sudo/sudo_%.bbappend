FILES_${PN}-visudo = "${sbindir}/visudo"
PACKAGES =+ "${PN}-visudo"

do_install_append () {
    # avoid non-readable sudo file to not break generation of pristine files on delta update server
    chmod 4755 ${D}${bindir}/sudo

    # link sudoers file for user to data partition
    ln -sf /mnt/data/user ${D}${sysconfdir}/sudoers.d/user
}
