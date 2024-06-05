HOMEPAGE = "https://github.com/aio-libs/aioftp"
SUMMARY = "ftp client/server for asyncio"

SECTION = "devel/python"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://license.txt;md5=86d3f3a95c324c9479bd8986968f4327"

RDEPENDS:${PN} = "python3-asyncio python3-io python3-logging"

SRC_URI[md5sum] = "a27556df39e8bfc41391e2b45e38f85f"
SRC_URI[sha256sum] = "28bb26d4616c7c381a1543281f987051b8d2d1d5bfaf023d9e7e2c2105c51bb9"

inherit setuptools3 pypi
