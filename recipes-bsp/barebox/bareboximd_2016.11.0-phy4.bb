require ../../../meta-phytec/recipes-bsp/barebox/barebox_${PV}.bb

SUMMERY = "bareboximd userspace tool"
PROVIDES = "${PN}"
FILESEXTRAPATHS_prepend := "${THISDIR}/barebox/:"

COMPATIBLE_MACHINE = "imx6ul-medusa"

PR = "${INC_PR}.0"

SRC_URI += " \
            file://0001-Fix-linking-with-new-ld,-based-on-u-boot.patch \
"

export TARGETCFLAGS="${TARGET_CC_ARCH} ${TOOLCHAIN_OPTIONS} ${CFLAGS} ${LDFLAGS}"
INTREE_DEFCONFIG = "${INTREE_DEFCONFIG_pn-barebox}"

do_configure_append() {
    # Compile target tools for barebox
    kconfig_set IMD y
    kconfig_set IMD_TARGET y
}

do_install () {
    # remove all stuff from the barebox build
    rm -rf ${D}/
    mkdir -p ${B}/

    install -d ${D}${base_sbindir}
    install -m 744 ${B}/scripts/bareboximd-target ${D}${base_sbindir}/bareboximd
}

PACKAGE_ARCH = "${TUNE_PKGARCH}"

FILES_${PN} = "${base_sbindir}"

do_deploy () {
}
