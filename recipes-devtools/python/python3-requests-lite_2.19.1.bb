DESCRIPTION = "Lite version (without HTTPS) of Python HTTP for Humans."
HOMEPAGE = "http://python-requests.org"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=bfbeafb85a2cee261510d65d5ec19156"

S = "${WORKDIR}/git"

SRCREV = "883caaf145fbe93bd0d208a6b864de9146087312"
PV = "2.19.1+git${SRCPV}"
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
