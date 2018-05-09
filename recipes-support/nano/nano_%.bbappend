RDEPENDS_${PN}_remove += "ncurses-terminfo"
RDEPENDS_${PN}_append += "ncurses-terminfo-base"

do_install_append() {
    # enable syntax highlighting
    install -d ${D}${sysconfdir}
    echo "include \"/usr/share/nano/*.nanorc\"" | tee -a ${D}${sysconfdir}/nanorc
}

FILES_${PN} += "${sysconfdir}/nanorc"
