DESCRIPTION = "Tools for MT3339/PA6H Based GPS"
HOMEPAGE = "https://github.com/f5eng/mt3339-utils"
SECTION = "console/utils"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f457cf0e901dfa16d32f5ca1999b7d9b"

RDEPENDS_${PN} = "bash coreutils-stdbuf python3-io"

PR = "r0"

FILESEXTRAPATHS_prepend := "${THISDIR}/mt3339-utils:"
SRC_URI = " \
    https://github.com/f5eng/mt3339-utils/archive/v${PV}.tar.gz \
    file://0003-Fix_variable_quoting_in_gpssend.patch \
    file://0011-epoinfo_adaptions.patch \
    file://0012-epoinfo_python3.patch \
"

SRC_URI[md5sum] = "6eb9e03b661b4f3812a0253fef8777a6"
SRC_URI[sha256sum] = "9fa55db63bd8e1de142a0caa1b14094a131dd64e8f6510e5d922cbdfaff23b5d"

S = "${WORKDIR}/mt3339-utils-${PV}"

do_install () {
    install -d ${D}${bindir}
    install -m 0755 ${S}/epoinfo ${D}${bindir}
    install -m 0755 ${S}/gpssend ${D}${bindir}
}
