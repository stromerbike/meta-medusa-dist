FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://add-libusb-directory-configure-arg.patch \
            file://do-not-try-to-use-gettext.patch \
            file://pubring.gpg \
"

DEPENDS += "libusb"
EXTRA_OECONF += "--enable-ccid-driver \
                 --with-libusb=${STAGING_INCDIR} \
"

PACKAGECONFIG_remove = "gnutls"

FILES_${PN} = "${bindir}/* ${datadir}/* ${libexecdir}/* ${sbindir}/*"

RDEPENDS_${PN} = "${PN}-gpgv"
PACKAGES =+ "${PN}-gpgv"
FILES_${PN}-gpgv = "${bindir}/gpgv*"

FILES_${PN}-gpgv += "${sysconfdir}/gnupg/pubring.gpg"

do_install_append() {
    # remove help texts
    rm -r ${D}${datadir}/gnupg/help.*

    # gpgv only needs pubring, gpg would also require trustdb.gpg
    install -m 0700 -d ${D}${sysconfdir}/gnupg
    install -m 0600 ${WORKDIR}/pubring.gpg ${D}${sysconfdir}/gnupg/pubring.gpg
}
