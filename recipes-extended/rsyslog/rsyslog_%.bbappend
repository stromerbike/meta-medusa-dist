FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
             file://rsyslog.conf \
"

PACKAGECONFIG_remove += "fmhttp gnutls imdiag imfile libgcrypt uuid"

PACKAGECONFIG[fmhash] = "--enable-fmhash,--disable-fmhash,,"

PACKAGECONFIG_append += "omprog"
PACKAGECONFIG[omprog] = "--enable-omprog,--disable-omprog,,"

PACKAGECONFIG_append += "omhttp"
PACKAGECONFIG[omhttp] = "--enable-omhttp,--disable-omhttp,curl,"

SYSTEMD_AUTO_ENABLE = "disable"
