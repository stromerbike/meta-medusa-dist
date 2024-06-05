DESCRIPTION = "Tools for MT3339/PA6H Based GPS"
HOMEPAGE = "https://github.com/f5eng/mt3339-utils"
SECTION = "console/utils"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f457cf0e901dfa16d32f5ca1999b7d9b"

RDEPENDS:${PN} = "bash coreutils-stdbuf python3-core python3-io"

PR = "r0"
PV = "1.0.4+gitr${SRCPV}"

FILESEXTRAPATHS:prepend := "${THISDIR}/mt3339-utils:"
SRC_URI = " \
    git://github.com/f5eng/mt3339-utils.git;protocol=https;branch=gps \
    file://0003-Fix_variable_quoting_in_gpssend.patch \
    file://0011-epoinfo_adaptions.patch \
    file://0012-epoinfo_python3.patch \
"
SRCREV = "766ec7966738bf14b7e298f506dbf9c7d98e4404"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/epoinfo ${D}${bindir}
    install -m 0755 ${S}/gpssend ${D}${bindir}
}
