RRECOMMENDS_${PN} = ""

EXTRA_OECONF += "--with-ssl=no"

PACKAGECONFIG_remove += "gnutls"
