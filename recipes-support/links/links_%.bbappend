DEPENDS_remove += "gpm"

PACKAGECONFIG[gpm] = "--with-gpm,--without-gpm,gpm"

EXTRA_OECONF_remove += "--enable-graphics"

FILES_${PN}_append = " ${ROOT_HOME}"

do_install_append() {
    install -d ${D}${ROOT_HOME}/.links
}
