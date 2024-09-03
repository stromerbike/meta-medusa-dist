HOMEPAGE = "https://github.com/encode/httpx"
SUMMARY = "A next generation HTTP client for Python."

SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=c624803bdf6fc1c4ce39f5ae11d7bd05"

RDEPENDS:${PN} = "python3-httpcore python3-rfc3986 python3-sniffio python3-certifi python3-codecs python3-netserver"

SRC_URI[sha256sum] = "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"

inherit pypi python_hatchling

DEPENDS += "\
    python3-hatch-fancy-pypi-readme-native \
"
