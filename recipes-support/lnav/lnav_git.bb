SUMMARY = "Log file navigator."
HOMEPAGE = "http://lnav.org"
SECTION = "console/utils"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e192536af38dcc40b361e488e0c79c0d"

PR = "r0"
PV = "0.11.2+gitr${SRCPV}"
DEPENDS = "curl libpcre2 ncurses readline sqlite3 zlib"

SRC_URI = " \
    git://github.com/tstack/${BPN}.git;protocol=https;branch=master \
    file://read-only-rootfs.patch \
    file://remove-test-from-subdirs.patch \
"
SRCREV = "3fefbbc82171df2de67ccf2b1f3d8ea908d9f29d"

S = "${WORKDIR}/git"

inherit autotools

EXTRA_OECONF = " \
    --disable-system-paths \
    --with-pcre2=${STAGING_DIR_TARGET}${prefix} \
"
