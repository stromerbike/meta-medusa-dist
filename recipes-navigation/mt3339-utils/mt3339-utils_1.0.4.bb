DESCRIPTION = "Tools for MT3339/PA6H Based GPS"
HOMEPAGE = "https://github.com/f5eng/mt3339-utils"
SECTION = "console/utils"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RDEPENDS_${PN} = "bash python-argparse python-codecs python-curses python-io python-math python-pyserial python-subprocess python-terminal python-threading"

PR = "r0"

SRC_URI = " \
    https://github.com/f5eng/mt3339-utils/archive/v${PV}.tar.gz \
"

SRC_URI[md5sum] = "6eb9e03b661b4f3812a0253fef8777a6"
SRC_URI[sha256sum] = "9fa55db63bd8e1de142a0caa1b14094a131dd64e8f6510e5d922cbdfaff23b5d"

S = "${WORKDIR}/${PN}-${PV}"

do_install () {
    install -d ${D}${bindir}
    install -m 0755 ${S}/epoinfo ${D}${bindir}
    install -m 0755 ${S}/epoloader ${D}${bindir}
    install -m 0755 ${S}/eporetrieve ${D}${bindir}
    install -m 0755 ${S}/gpsinit ${D}${bindir}
    install -m 0755 ${S}/gpssend ${D}${bindir}
    install -m 0755 ${S}/gpsstatus ${D}${bindir}

    install -d ${D}${sysconfdir}
    install -m 0644 ${S}/*.conf ${D}${sysconfdir}
}
