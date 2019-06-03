RDEPENDS_${PN}_remove += "ncurses-terminfo"
RDEPENDS_${PN}_append += "ncurses-terminfo-base"

DEPENDS_remove += "file"

FILES_${PN} += "${sysconfdir}/nanorc"

do_install_append() {
    # enable syntax highlighting
    install -d ${D}${sysconfdir}
    echo "include \"/usr/share/nano/*.nanorc\"" | tee -a ${D}${sysconfdir}/nanorc
    echo "set linenumbers" | tee -a ${D}${sysconfdir}/nanorc
    echo "set tabsize 4" | tee -a ${D}${sysconfdir}/nanorc
    echo "set tabstospaces" | tee -a ${D}${sysconfdir}/nanorc
}

PACKAGECONFIG[libmagic] = "--enable-libmagic,--disable-libmagic,file"
