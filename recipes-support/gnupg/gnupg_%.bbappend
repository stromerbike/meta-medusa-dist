FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://pubring.gpg \
"

RRECOMMENDS_${PN} = ""

FILES_${PN} = "${bindir}/* ${datadir}/* ${libexecdir}/* ${sbindir}/*"

RDEPENDS_${PN} = "${PN}-gpgv"
PACKAGES =+ "${PN}-gpgv"
FILES_${PN}-gpgv = "${bindir}/gpgv*"

FILES_${PN}-gpgv += "${sysconfdir}/gnupg/pubring.gpg"

do_install_append() {
    # gpgv only needs pubring, gpg would also require trustdb.gpg
    install -m 0700 -d ${D}${sysconfdir}/gnupg
    install -m 0600 ${WORKDIR}/pubring.gpg ${D}${sysconfdir}/gnupg/pubring.gpg
}
