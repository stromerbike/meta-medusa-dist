SUMMARY = "Log file navigator."
HOMEPAGE = "http://lnav.org"
SECTION = "console/utils"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e192536af38dcc40b361e488e0c79c0d"

PR = "r0"
PV = "0.11.1+gitr${SRCPV}"
DEPENDS = "curl libpcre2 ncurses readline sqlite3 zlib"

# ${@bb.utils.contains("IMAGE_FEATURES", "read-only-rootfs", "file://read-only-rootfs.patch", "", d)}

SRC_URI = " \
    git://github.com/tstack/${BPN}.git;protocol=https;branch=master \
    file://dont-add-PRCE2_HOME-to-the-search-path-if-it-is-empty.patch \
    file://remove-test-from-subdirs.patch \
    ${@bb.utils.contains("IMAGE_FEATURES", "read-only-rootfs", "file://read-only-rootfs.patch", "", d)} \
"
SRCREV = "48798076c194e878b61b84392c391fb4e36c2188"

S = "${WORKDIR}/git"

inherit autotools

EXTRA_OECONF += "--disable-system-paths"
