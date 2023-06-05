DESCRIPTION = "A tiny console 4x6 font"
HOMEPAGE = "https://github.com/nbah22/tiny-font"
SECTION = "console/utils"
LICENSE = "PD"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/PD;md5=b3597d12946881e13cb3b548d1173851"

PR = "r0+gitr${SRCPV}"

SRCREV = "a238c565d10a7539a0f036c56e2739e713066316"

S = "${WORKDIR}/git"

SRC_URI = " \
    git://github.com/nbah22/tiny-font.git;protocol=https;branch=master \
"

do_install() {
    install -d ${D}${datadir}/consolefonts
    install -m 0644 ${S}/font4x6.psf.gz ${D}${datadir}/consolefonts
}

FILES:${PN} = "${datadir}/consolefonts"
