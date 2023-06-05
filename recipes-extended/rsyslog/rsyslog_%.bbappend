FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
             file://action.c.patch \
             file://omhttp.c.patch \
             file://50-stromer.conf \
             file://rsyslog.conf \
"

PACKAGECONFIG:remove = " fmhttp gnutls imdiag imfile libgcrypt uuid"

PACKAGECONFIG[fmhash] = "--enable-fmhash,--disable-fmhash,,"

PACKAGECONFIG:append = " omprog"
PACKAGECONFIG[omprog] = "--enable-omprog,--disable-omprog,,"

PACKAGECONFIG:append = " omhttp"
PACKAGECONFIG[omhttp] = "--enable-omhttp,--disable-omhttp,curl,"

do_install:append() {
    install -d ${D}${sysconfdir}/rsyslog.d
    install -m 0644 ${WORKDIR}/50-stromer.conf ${D}${sysconfdir}/rsyslog.d
}
