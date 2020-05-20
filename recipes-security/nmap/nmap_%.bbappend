PACKAGECONFIG_remove += "ncat nping ndiff"

EXTRA_OECONF += "--without-liblua --disable-nls"

do_install_append() {
    rm ${D}${datadir}/${BPN}/nmap-mac-prefixes
    rm ${D}${datadir}/${BPN}/nmap-os-db
}

RDEPENDS_${PN}_remove += "python"
