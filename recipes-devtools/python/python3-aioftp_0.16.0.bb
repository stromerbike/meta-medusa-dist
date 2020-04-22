HOMEPAGE = "https://github.com/aio-libs/aioftp"
SUMMARY = "ftp client/server for asyncio"

SECTION = "devel/python"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://license.txt;md5=86d3f3a95c324c9479bd8986968f4327"

RDEPENDS_${PN} = "python3-asyncio python3-io python3-logging python3-pathlib"

SRC_URI[md5sum] = "42ef7e08a0ccb7eaf5525deff94a41ab"
SRC_URI[sha256sum] = "94648d17dd3ca44614b59e8f795991b447258d82aa1b4cfecc0aceccf01b7495"

inherit setuptools3 pypi
