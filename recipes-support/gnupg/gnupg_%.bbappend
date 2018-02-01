FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://public.gpg \
"

do_install_append() {
    gpg --homedir ${B} --import ${WORKDIR}/public.gpg

    # gpgv only needs pubring, gpg would also require trustdb.gpg
    install -m 0700 -d ${D}${sysconfdir}/gnupg
    install -m 0600 ${B}/pubring.gpg ${D}${sysconfdir}/gnupg/pubring.gpg
}

FILES_${PN} += "${sysconfdir}/gnupg/pubring.gpg"
