FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://id_rsa_medusa_root.pub \
            file://id_rsa_medusa_user.pub \
            file://ssh_host_dsa_key \
            file://ssh_host_dsa_key.pub \
            file://ssh_host_ecdsa_key \
            file://ssh_host_ecdsa_key.pub \
            file://ssh_host_ed25519_key \
            file://ssh_host_ed25519_key.pub \
            file://ssh_host_rsa_key \
            file://ssh_host_rsa_key.pub \
"

do_install_append() {
    # install public part of ssh key for "root"
    install -d ${D}/home/root/.ssh/
    install -m 0755 ${WORKDIR}/id_rsa_medusa_root.pub ${D}/home/root/.ssh/authorized_keys

    # install public part of ssh key for "user"
    install -d ${D}/home/user/.ssh/
    install -m 0755 ${WORKDIR}/id_rsa_medusa_user.pub ${D}/home/user/.ssh/authorized_keys

    # install keys used in sshd_config and sshd_config_readonly
    install -d ${D}${localstatedir}/ssh    
    for dir in ${sysconfdir} ${localstatedir}; do
        install -m 0600 ${WORKDIR}/ssh_host_dsa_key ${D}$dir/ssh
        install -m 0644 ${WORKDIR}/ssh_host_dsa_key.pub ${D}$dir/ssh
        install -m 0600 ${WORKDIR}/ssh_host_ecdsa_key ${D}$dir/ssh
        install -m 0644 ${WORKDIR}/ssh_host_ecdsa_key.pub ${D}$dir/ssh
        install -m 0600 ${WORKDIR}/ssh_host_ed25519_key ${D}$dir/ssh
        install -m 0644 ${WORKDIR}/ssh_host_ed25519_key.pub ${D}$dir/ssh
        install -m 0600 ${WORKDIR}/ssh_host_rsa_key ${D}$dir/ssh
        install -m 0644 ${WORKDIR}/ssh_host_rsa_key.pub ${D}$dir/ssh
    done

    # allow root login
    sed -i 's/^[#[:space:]]*PermitRootLogin.*/PermitRootLogin yes/' ${D}${sysconfdir}/ssh/sshd_config*
}

FILES_${PN} += " \
                /home/root/.ssh/authorized_keys \
                /home/user/.ssh/authorized_keys \
"
