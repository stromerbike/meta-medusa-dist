SUMMARY = "i.MX6 SDMA firmware"
LICENSE = "CLOSED"

PR = "r0"

RDEPENDS_${PN} = "kernel-module-imx-sdma"

SRC_URI = "file://sdma-imx6q.bin"

FILES_${PN} = "${base_libdir}/firmware/imx/sdma/sdma-imx6q.bin"

do_install() {
    install -d ${D}/${base_libdir}/firmware/imx/sdma
    install -m 644 ${WORKDIR}/sdma-imx6q.bin ${D}/${base_libdir}/firmware/imx/sdma/sdma-imx6q.bin
}
