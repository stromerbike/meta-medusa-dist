HOMEPAGE = "https://github.com/encode/httpx"
SUMMARY = "A next generation HTTP client for Python."

SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=62cf950961605b0103ed2b4ea9f0f04b"

RDEPENDS_${PN} = "python3-httpcore python3-rfc3986 python3-sniffio python3-certifi python3-codecs python3-netrc python3-netserver"

SRC_URI[md5sum] = "78bbfb911e0b0be21290b1cccdcd6cd8"
SRC_URI[sha256sum] = "126424c279c842738805974687e0518a94c7ae8d140cd65b9c4f77ac46ffa537"

inherit setuptools3 pypi
