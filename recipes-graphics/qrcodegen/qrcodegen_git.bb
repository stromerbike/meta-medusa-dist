SUMMARY = "Qrcodegen is a flexible and accurate QR Code generator library"
HOMEPAGE = "https://github.com/nayuki/QR-Code-generator"
SECTION = "libs"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=53bf6d66a7f9f4ac593334cbd9cf8f5a"

PR = "r0"
PV = "0.0.0+gitr${SRCPV}"

SRC_URI = " \
           git://github.com/nayuki/QR-Code-generator.git;protocol=git;branch=master \
"
SRCREV = "71c75cfeb0f06788ebc43a39b704c39fcf5eba7c"

S = "${WORKDIR}/git"

TARGET_CC_ARCH += "${LDFLAGS}"

do_compile() {
#    ${CC} -shared -o ${BPN} -fPIC QrCode.cpp
    ${CC} -std=c++11 -O -shared -o libqrcodegen.so.1.6.0 -fPIC cpp/QrCode.cpp
}

do_install() {
    install -d ${D}${libdir}
    install libqrcodegen.so.1.6.0 ${D}${libdir}
#    install cpp/QrCode.hpp
#    install -m 0755 ${BPN} ${D}${bindir}
}
