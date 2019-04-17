DESCRIPTION = "Lite version (without HTTPS) of Python HTTP for Humans."
HOMEPAGE = "http://python-requests.org"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=a8d5a1d1c2d53025e2282c511033f6f7"

S = "${WORKDIR}/git"

SRCREV = "5a1e738ea9c399c3f59977f2f98b083986d6037a"
PV = "2.21.0+git${SRCPV}"
SRC_URI = "git://github.com/requests/requests.git;branch=master \
           file://require-urllib3-lite.patch \
"

inherit setuptools3 python3native

RDEPENDS_${PN} += " \
    ${PYTHON_PN}-chardet \
    ${PYTHON_PN}-certifi \
    ${PYTHON_PN}-idna \
    ${PYTHON_PN}-json \
    ${PYTHON_PN}-netserver \
    ${PYTHON_PN}-urllib3-lite \
"

BBCLASSEXTEND = "native nativesdk"
