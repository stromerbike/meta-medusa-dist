HOMEPAGE = "https://github.com/aio-libs/aioftp"
SUMMARY = "ftp client/server for asyncio"

SECTION = "devel/python"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://license.txt;md5=86d3f3a95c324c9479bd8986968f4327"

RDEPENDS_${PN} = "python3-asyncio python3-io python3-logging python3-pathlib"

SRC_URI[md5sum] = "804eb42a4910967808315c868ae9f79a"
SRC_URI[sha256sum] = "5711c03433b510c101e9337069033133cca19b508b5162b414bed24320de6c18"

inherit setuptools3 pypi
