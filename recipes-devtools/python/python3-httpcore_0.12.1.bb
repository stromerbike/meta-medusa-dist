HOMEPAGE = "https://github.com/encode/httpcore"
SUMMARY = "A minimal HTTP client."

SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=1c1f23b073da202e1f4f9e426490210c"

RDEPENDS_${PN} = "python3-h11 python3-sniffio"

SRC_URI[md5sum] = "6b27f33565f1127feaf15b59f650659d"
SRC_URI[sha256sum] = "3c5fcd97c52c3f6a1e4d939d776458e6177b5c238b825ed51d72840e582573b5"

inherit setuptools3 pypi
