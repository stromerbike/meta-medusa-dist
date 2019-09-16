PACKAGECONFIG_remove += "gnutls"

PACKAGECONFIG_append += "omprog"
PACKAGECONFIG[omprog] = "--enable-omprog,--disable-omprog,"

SYSTEMD_AUTO_ENABLE = "disable"
