SUMMARY = "Log file navigator."
HOMEPAGE = "https://lnav.org"
SECTION = "console/utils"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e192536af38dcc40b361e488e0c79c0d"

PR = "r0"
PV = "0.12.2+gitr${SRCPV}"
DEPENDS = "curl libpcre2 ncurses readline sqlite3 zlib"

SRC_URI = " \
    git://github.com/tstack/${BPN}.git;protocol=https;branch=master \
    file://read-only-rootfs.patch \
    file://remove-test-from-subdirs.patch \
"
SRCREV = "f521c7fedace3f41635cedd822fa1c98f20065f7"

S = "${WORKDIR}/git"

inherit autotools

EXTRA_OECONF = " \
    --disable-system-paths \
    --with-pcre2=${STAGING_DIR_TARGET}${prefix} \
"
