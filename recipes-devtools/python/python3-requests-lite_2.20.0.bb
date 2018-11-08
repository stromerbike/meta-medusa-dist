DESCRIPTION = "Lite version (without HTTPS) of Python HTTP for Humans."
HOMEPAGE = "http://python-requests.org"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=a8d5a1d1c2d53025e2282c511033f6f7"

S = "${WORKDIR}/git"

SRCREV = "bd840450c0d1e9db3bf62382c15d96378cc3a056"
PV = "2.20.0+git${SRCPV}"
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
