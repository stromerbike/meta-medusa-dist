do_configure:append() {
    kconfig_set BAREBOXENV_TARGET n
    kconfig_set BAREBOXCRC32_TARGET n
    kconfig_set KERNEL_INSTALL_TARGET n
}

do_install() {
    # remove all stuff from the barebox build
    rm -rf ${D}/
    mkdir -p ${B}/

    install -d ${D}${base_sbindir}
    install -m 744 ${B}/scripts/bareboximd-target ${D}${base_sbindir}/bareboximd
}
