DESCRIPTION = "Bluez Tools"
HOMEPAGE = "http://code.google.com/p/bluez-tools/"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=12f884d2ae1ff87c09e5b7ccc2c4ca7e"

RDEPENDS_${PN} = "bluez5 ${@bb.utils.contains('PACKAGECONFIG', 'obex', 'obexd', '', d)}"
DEPENDS = "glib-2.0 dbus-glib readline"

PR = "r0+gitr${SRCPV}"

SRCREV = "a80cecd0d73c86c7f7bc8f2b6a0987fae5136465"

S = "${WORKDIR}/git"

SRC_URI = "git://github.com/khvzak/bluez-tools.git;protocol=git"

inherit autotools pkgconfig

EXTRA_AUTORECONF_append = " -I ${STAGING_DATADIR}/aclocal"

PACKAGECONFIG ??= " \
    obex \
"

PACKAGECONFIG[obex] = ","

do_install_append() {
    if ${@bb.utils.contains('PACKAGECONFIG', 'obex', 'false', 'true', d)}; then
        rm ${D}${bindir}/bt-obex
    fi
}
