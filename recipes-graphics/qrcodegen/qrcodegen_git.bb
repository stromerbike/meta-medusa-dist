SUMMARY = "Qrcodegen is a flexible and accurate QR Code generator library"
HOMEPAGE = "https://www.nayuki.io/page/qr-code-generator-library"
SECTION = "libs"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://Readme.markdown;beginline=69;md5=794c65ba35e2a4bebd467469bab52040"

PR = "r0"
BASEPV = "1.8.0"
PV = "${BASEPV}+gitr${SRCPV}"

SRC_URI = "git://github.com/nayuki/QR-Code-generator.git;protocol=https;branch=master"
SRCREV = "720f62bddb7226106071d4728c292cb1df519ceb"

S = "${WORKDIR}/git"

FILES:${PN} += "${libdir}/lib${BPN}.so"
FILES_SOLIBSDEV = ""

INSANE_SKIP:${PN} = "dev-so"
RPROVIDES:${PN} += "lib${BPN}.so"

TARGET_CC_ARCH += "${LDFLAGS}"

do_compile() {
    ${CC} -std=c++11 -O -shared -fPIC -Wl,-soname,lib${BPN}.so.1 cpp/qrcodegen.cpp -o lib${BPN}.so.${BASEPV}
}

do_install() {
    install -d ${D}${libdir}
    oe_libinstall -so lib${BPN} ${D}${libdir}
    install -d ${D}${includedir}/${BPN}
    install cpp/qrcodegen.hpp ${D}${includedir}/${BPN}
}
