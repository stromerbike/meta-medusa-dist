FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
             file://50-stromer.conf \
             file://rsyslog.conf \
             file://rsyslog.service.in.patch \
"

PACKAGECONFIG_remove += "fmhttp gnutls imdiag imfile libgcrypt uuid"

PACKAGECONFIG[fmhash] = "--enable-fmhash,--disable-fmhash,,"

PACKAGECONFIG_append += "omprog"
PACKAGECONFIG[omprog] = "--enable-omprog,--disable-omprog,,"

PACKAGECONFIG_append += "omhttp"
PACKAGECONFIG[omhttp] = "--enable-omhttp,--disable-omhttp,curl,"

do_install_append() {
    install -d ${D}${sysconfdir}/rsyslog.d
    install -m 0644 ${WORKDIR}/50-stromer.conf ${D}${sysconfdir}/rsyslog.d
}
