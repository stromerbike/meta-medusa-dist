RDEPENDS:${PN}:remove = " ncurses-terminfo"
RDEPENDS:${PN}:append = " ncurses-terminfo-base"

DEPENDS:remove = " file"

FILES:${PN} += "${sysconfdir}/nanorc"

do_install:append() {
    # enable syntax highlighting
    install -d ${D}${sysconfdir}
    echo "include \"/usr/share/nano/*.nanorc\"" | tee -a ${D}${sysconfdir}/nanorc
    echo "set linenumbers" | tee -a ${D}${sysconfdir}/nanorc
    echo "set tabsize 4" | tee -a ${D}${sysconfdir}/nanorc
    echo "set tabstospaces" | tee -a ${D}${sysconfdir}/nanorc
}

PACKAGECONFIG[libmagic] = "--enable-libmagic,--disable-libmagic,file"
