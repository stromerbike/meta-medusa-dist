SUMMARY = "Lite version (without HTTPS) of Python HTTP library with thread-safe connection pooling, file post support, sanity friendly, and more"
HOMEPAGE = "https://github.com/shazow/urllib3"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=ea114851ad9a8c311aac8728a681a067"

S = "${WORKDIR}/git"

SRCREV = "9c61bdaafc9022a8f1e1d0a5334c46b61651508a"
PV = "1.24.3+git${SRCPV}"
SRC_URI = "git://github.com/urllib3/urllib3.git;branch=1.24-series \
"

inherit setuptools3 python3native

RDEPENDS_${PN} += "\
    ${PYTHON_PN}-email \
    ${PYTHON_PN}-netclient \
    ${PYTHON_PN}-threading \
"

BBCLASSEXTEND = "native nativesdk"
