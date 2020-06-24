HOMEPAGE = "https://github.com/changyuheng/aioserial"
SUMMARY = "pyserial-asyncio for humans"

DESCRIPTION = "A Python package that combines asyncio and pySerial."

SECTION = "devel/python"
LICENSE = "MPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=815ca599c9df247a0c7f619bab123dad"

RDEPENDS_${PN} = "python3-pyserial python3-asyncio"

SRC_URI[md5sum] = "65ef17d01d26b5a6f8fb351e3c2606cc"
SRC_URI[sha256sum] = "2f396da8549721c8e76204a13286db83a4e5f195a046867b669ebad0929c1847"

inherit setuptools3 pypi
