SUMMARY = "G3log is an asynchronous, crash safe, logger that is easy to use with default logging sinks or you can add your own."
HOMEPAGE = "https://github.com/KjellKod/g3log"
SECTION = "libs"

# Remark: Warnings occur when "UNLICENSE" is used as LICENSE.
LICENSE = "UNLIC"
LIC_FILES_CHKSUM = "file://LICENSE;md5=7246f848faa4e9c9fc0ea91122d6e680"

PR = "r0"
PV = "1.3+gitr${SRCPV}"

SRC_URI = " \
            git://github.com/KjellKod/${BPN}.git;protocol=git;branch=master \
            file://0001-fix_version.patch \
"
SRCREV = "82df2168aaa6b6f1e077de15356fde8fd6f918dc"

S = "${WORKDIR}/git"

# add g3log to main packages
# see https://lists.yoctoproject.org/pipermail/yocto/2013-December/017509.html
FILES_${PN} += "${libdir}/*"
FILES_${PN}-dev += "${libdir}/cmake"
FILES_SOLIBSDEV = ""

INSANE_SKIP_${PN} = "dev-so"
RPROVIDES_${PN} += "libg3logger.so"

inherit cmake

EXTRA_OECMAKE = " \
                  -DCMAKE_BUILD_TYPE=Release \
                  -DUSE_DYNAMIC_LOGGING_LEVELS=1 \
                  -DCPACK_INSTALL_PREFIX=${prefix} \
"
