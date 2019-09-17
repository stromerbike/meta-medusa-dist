FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
             file://rsyslog.conf \
"

PACKAGECONFIG_remove += "gnutls"

PACKAGECONFIG_append += "omprog"
PACKAGECONFIG[omprog] = "--enable-omprog,--disable-omprog,"

SYSTEMD_AUTO_ENABLE = "disable"
