DESCRIPTION = "Tools for MT3339/PA6H Based GPS"
HOMEPAGE = "https://github.com/f5eng/mt3339-utils"
SECTION = "console/utils"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RDEPENDS_${PN} = "python-argparse python-io"

SRC_URI = "\
	https://raw.githubusercontent.com/f5eng/mt3339-utils/v1.0.4/epoinfo \
"

SRC_URI[md5sum] = "db6abd8439d57b2d608cff6488bb177e"
SRC_URI[sha256sum] = "34ee57d3125d7fe128f75eb49347c1422d4e1a5c2c4b207de608beb832dd9cdd"

do_install () {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/epoinfo ${D}${bindir}
}
