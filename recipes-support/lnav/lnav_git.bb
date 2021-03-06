SUMMARY = "Log file navigator."
HOMEPAGE = "http://lnav.org"
SECTION = "console/utils"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e192536af38dcc40b361e488e0c79c0d"

PR = "r0"
PV = "0.8.5+gitr${SRCPV}"
DEPENDS = "curl libpcre ncurses readline sqlite3 zlib"

SRC_URI = " \
    git://github.com/tstack/${BPN}.git;protocol=git;branch=master \
    file://use-native-gcc-only-for-bin2c-and-ptimec.patch \
    ${@bb.utils.contains("IMAGE_FEATURES", "read-only-rootfs", "file://read-only-rootfs.patch", "", d)} \
"
SRCREV = "832f980ab9db5184837a2204a19d496cb8e61b2d"

S = "${WORKDIR}/git"

inherit autotools
