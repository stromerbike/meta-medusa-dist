SUMMARY = "G3log is an asynchronous, crash safe, logger that is easy to use with default logging sinks or you can add your own."
HOMEPAGE = "https://github.com/KjellKod/g3log"
SECTION = "libs"

# Remark: Warnings occur when "UNLICENSE" is used as LICENSE.
LICENSE = "UNLIC"
LIC_FILES_CHKSUM = "file://LICENSE;md5=7246f848faa4e9c9fc0ea91122d6e680"

PR = "r0"

SRC_URI = " \
    https://github.com/KjellKod/g3log/archive/${PV}.tar.gz;downloadfilename=g3log_${PV}.tar.gz \
    file://0001-fix_version.patch \
"

SRC_URI[md5sum] = "9c7d427b4624530c62914f77e87d3d55"
SRC_URI[sha256sum] = "0ed1983654fdd8268e051274904128709c3d9df8234acf7916e9015199b0b247"

# This commit does not belong to any branch on this repository, and may belong to a fork outside of the repository.
WARN_QA:remove = "src-uri-bad"

# add g3log to main packages
# see https://lists.yoctoproject.org/pipermail/yocto/2013-December/017509.html
FILES:${PN} += "${libdir}/*"
FILES:${PN}-dev += "${libdir}/cmake"
FILES_SOLIBSDEV = ""

INSANE_SKIP:${PN} = "dev-so"
RPROVIDES:${PN} += "libg3logger.so"

inherit cmake

EXTRA_OECMAKE = " \
                  -DCMAKE_BUILD_TYPE=Release \
                  -DUSE_DYNAMIC_LOGGING_LEVELS=1 \
                  -DENABLE_FATAL_SIGNALHANDLING=OFF \
                  -DCPACK_INSTALL_PREFIX=${prefix} \
"
