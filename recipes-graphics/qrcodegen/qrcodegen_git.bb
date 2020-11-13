SUMMARY = "Qrcodegen is a flexible and accurate QR Code generator library"
HOMEPAGE = "https://www.nayuki.io/page/qr-code-generator-library"
SECTION = "libs"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://Readme.markdown;beginline=175;md5=063a6c9f330bca206cb38453ceb96785"

PR = "r0"
PV = "1.6.0"
#PV = "0.0.0+gitr${SRCPV}"

SRC_URI = "git://github.com/nayuki/QR-Code-generator.git;protocol=git;branch=master"
SRCREV = "71c75cfeb0f06788ebc43a39b704c39fcf5eba7c"

S = "${WORKDIR}/git"

TARGET_CC_ARCH += "${LDFLAGS}"

do_compile() {
    ${CC} -std=c++11 -O -shared -o lib${BPN}.so.${PV} -fPIC cpp/QrCode.cpp
}

do_install() {
    install -d ${D}${libdir}
    install lib${BPN}.so.${PV} ${D}${libdir}
    ln -s -r ${D}${libdir}/lib${BPN}.so.${PV} ${D}${libdir}/lib${BPN}.so
    install -d ${D}${includedir}/${BPN}
    install cpp/QrCode.hpp ${D}${includedir}/${BPN}
}
