do_install_append () { 
    ln -sf /mnt/data/user ${D}${sysconfdir}/sudoers.d/user
}
