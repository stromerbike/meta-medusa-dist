SUMMARY = "G3log is an asynchronous, crash safe, logger that is easy to use with default logging sinks or you can add your own."
HOMEPAGE = "https://github.com/KjellKod/g3log"
SECTION = "libs"

# Remark: Warnings occur when "UNLICENSE" is used as LICENSE.
LICENSE = "UNLIC"
LIC_FILES_CHKSUM = "file://LICENSE;md5=7246f848faa4e9c9fc0ea91122d6e680"

PR = "r0"

SRC_URI = " \
    https://github.com/KjellKod/g3log/archive/${PV}.tar.gz;downloadfilename=g3log_${PV}.tar.gz \
"

SRC_URI[md5sum] = "027acefec860f14e06a4dee0db996263"
SRC_URI[sha256sum] = "0da42ffcbade15b01c25683682a8f5703ec0adfe148d396057f01f1f020f3734"

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
