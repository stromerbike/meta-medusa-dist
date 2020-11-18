HOMEPAGE = "https://github.com/python-hyper/rfc3986"
SUMMARY = "A Python Implementation of RFC3986 including validations"

SECTION = "devel/python"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=03731a0e7dbcb30cecdcec77cc93ec29"

RDEPENDS_${PN} = "python3-idna"

SRC_URI[md5sum] = "1b03ad2853e33d47eea698571255247c"
SRC_URI[sha256sum] = "112398da31a3344dc25dbf477d8df6cb34f9278a94fee2625d89e4514be8bb9d"

inherit setuptools3 pypi
