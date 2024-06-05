HOMEPAGE = "https://github.com/encode/httpcore"
SUMMARY = "A minimal HTTP client."

SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=1c1f23b073da202e1f4f9e426490210c"

RDEPENDS:${PN} = "python3-h11 python3-sniffio"

SRC_URI[md5sum] = "881211271c5fea2aba9e97dc0e7747e8"
SRC_URI[sha256sum] = "cc045a3241afbf60ce056202301b4d8b6af08845e3294055eb26b09913ef903c"

inherit setuptools3 pypi
