DESCRIPTION = "Tools for updating and dumping firmware from GPS receivers utilizing the MT3333 or MT3339 chipset"
HOMEPAGE = "https://github.com/dimhoff/mt333x-fw-utils"
SECTION = "console/utils"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=22c6ab45312590e4752810768e93ef66"

RDEPENDS_${PN} = "python-argparse python-pyserial"

PR = "r0+gitr${SRCPV}"

SRCREV = "2d39fb9caacc4dc1067e5d131cab127735a93fe3"

S = "${WORKDIR}/git"

SRC_URI = " \
            git://github.com/dimhoff/mt333x-fw-utils.git;protocol=git \
            file://MTK_AllInOne_DA_MT3329_v4.02.bin \
            file://MTK_AllInOne_DA_MT3333.bin \
            file://MTK_AllInOne_DA_MT3339_E3.bin \
"

FILES_${PN} = "${sysconfdir}/mediatek/"

do_install () {
    install -d ${D}${sysconfdir}/mediatek/
    for file in $(find ${WORKDIR}/git -maxdepth 1 -type f -name "*.py"); do
        install -m 0755 "$file" ${D}${sysconfdir}/mediatek/
    done
    for file in $(find ${WORKDIR} -maxdepth 1 -type f -name "*.bin"); do
        install -m 0644 "$file" ${D}${sysconfdir}/mediatek/
    done
}
