SUMMARY = "interceptty is a program that sits between a real or fake serial port and an application, and logs everything that passes through it"
HOMEPAGE = "https://github.com/geoffmeyers/interceptty"
SECTION = "console/utils"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

PR = "r0"
PV = "0.6+gitr${SRCPV}"

SRC_URI = " \
           git://github.com/geoffmeyers/${BPN}.git;protocol=git;branch=master \
           file://interceptty-nicedump-print-timestamp.patch \
           file://Skip-host-file-system-checks-when-cross-compiling.patch \
"
SRCREV = "3b6fbbb748d6707a9287181eda66ff07b9629fab"

S = "${WORKDIR}/git"

inherit autotools

PACKAGES =+ "${PN}-nicedump"
RDEPENDS_${PN}-nicedump += "${PN} perl perl-module-time-hires"
FILES_${PN}-nicedump = "${bindir}/${PN}-nicedump"

do_configure_prepend() {
    cp ${S}/README.md ${S}/README
}
