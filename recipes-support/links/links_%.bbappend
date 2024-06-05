DEPENDS:remove = " gpm"

PACKAGECONFIG[gpm] = "--with-gpm,--without-gpm,gpm"

EXTRA_OECONF:remove = " --enable-graphics"

FILES:${PN}:append = " ${ROOT_HOME}"

do_install:append() {
    install -d ${D}${ROOT_HOME}/.links
}
