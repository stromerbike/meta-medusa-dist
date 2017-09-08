FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
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

    # allow root login and empty passwords
    sed -i 's/^[#[:space:]]*PermitRootLogin.*/PermitRootLogin yes/' ${D}${sysconfdir}/ssh/sshd_config*
    sed -i 's/^[#[:space:]]*PermitEmptyPasswords.*/PermitEmptyPasswords yes/' ${D}${sysconfdir}/ssh/sshd_config*

    echo "\n# Restrict IP addresses to local, stromer and 89grad servers" | tee -a ${D}${sysconfdir}/ssh/sshd_config*
    echo "AllowUsers root@192.168.*.* root@10.3.*.* root@10.89.23.*" | tee -a ${D}${sysconfdir}/ssh/sshd_config*
}
