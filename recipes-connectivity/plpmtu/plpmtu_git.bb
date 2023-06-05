SUMMARY = "Perform Path MTU Discovery without relying on ICMP errors, which are often not delivered."
HOMEPAGE = "https://github.com/Kavarenshko/plp-mtu-discovery"
SECTION = "console/utils"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=53bf6d66a7f9f4ac593334cbd9cf8f5a"

PR = "r0"
PV = "0.0.0+gitr${SRCPV}"

SRC_URI = " \
           git://github.com/Kavarenshko/plp-mtu-discovery.git;protocol=https;branch=master \
"
SRCREV = "6a8abc4906744f0fac07f980219bd99378b5fb3d"

S = "${WORKDIR}/git"

TARGET_CC_ARCH += "${LDFLAGS}"

do_compile() {
    ${CC} mtu_discovery.c mtu.c -o ${BPN}
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${BPN} ${D}${bindir}
}
