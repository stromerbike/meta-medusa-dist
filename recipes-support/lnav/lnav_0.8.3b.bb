SUMMARY = "Log file navigator."
HOMEPAGE = "http://lnav.org"
SECTION = "console/utils"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e192536af38dcc40b361e488e0c79c0d"

PR = "r0"
DEPENDS = "curl libpcre ncurses readline sqlite3 zlib"

SRC_URI = " \
    https://github.com/tstack/lnav/archive/v${PV}.tar.gz;downloadfilename=lnav_${PV}.tar.gz \
    file://read-only-rootfs.patch \
    file://use-native-gcc-only-for-bin2c-and-ptimec.patch \
"

SRC_URI[md5sum] = "4e35ca53ffebd566ba26bc22decf8aa2"
SRC_URI[sha256sum] = "095ea6e61d3fd6f9864e7dd9d977c20dc55e7dec7d4910e9257d400b51b9905e"

inherit autotools
