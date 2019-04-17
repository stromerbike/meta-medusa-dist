SUMMARY = "Lite version (without HTTPS) of Python HTTP library with thread-safe connection pooling, file post support, sanity friendly, and more"
HOMEPAGE = "https://github.com/shazow/urllib3"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=ea114851ad9a8c311aac8728a681a067"

S = "${WORKDIR}/git"

SRCREV = "a6ec68a5c5c5743c59fe5c62c635c929586c429b"
PV = "1.24.1+git${SRCPV}"
SRC_URI = "git://github.com/urllib3/urllib3.git;branch=release \
"

inherit setuptools3 python3native

RDEPENDS_${PN} += "\
    ${PYTHON_PN}-email \
    ${PYTHON_PN}-netclient \
    ${PYTHON_PN}-threading \
"

BBCLASSEXTEND = "native nativesdk"
