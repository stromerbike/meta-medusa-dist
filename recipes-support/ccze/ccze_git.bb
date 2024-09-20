SUMMARY = "This is CCZE, a fast log colorizer written in C, intended to be a drop-in replacement for colorize (http://colorize.raszi.hu)."
HOMEPAGE = "https://github.com/stromerbike/ccze"
SECTION = "console/utils"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

PR = "r0"
PV = "0.2.1-2+gitr${SRCPV}"
DEPENDS = "libpcre ncurses"

SRC_URI = " \
           git://github.com/stromerbike/${BPN}.git;protocol=https;branch=master \
           file://pkgconfig.patch \
"
SRCREV = "7c7927fba98275c10ae614bd8c1a1367f87a258c"

S = "${WORKDIR}/git"

inherit autotools pkgconfig

TARGET_CC_ARCH += "${LDFLAGS}"

PACKAGES =+ "${PN}-cssdump"
FILES:${PN}-cssdump = "${bindir}/${PN}-cssdump"
