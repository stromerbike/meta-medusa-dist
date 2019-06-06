HOMEPAGE = "https://github.com/pyserial/pyserial-asyncio"
SUMMARY = "Python Serial Port Extension - Asynchronous I/O support"

DESCRIPTION = "Async I/O extension package for the Python Serial Port Extension for OSX, Linux, BSD"

SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=e8a4b0e902265f3a190eff46d4ca7efd"

RDEPENDS_${PN} = "python3-pyserial python3-asyncio"

SRC_URI[md5sum] = "67244fdc11cc31cf0ebf675c271c71d8"
SRC_URI[sha256sum] = "c40677a8874d8c24d4423a97498746de776f6dbcd0efbb8fa43dcf011a589aee"

inherit setuptools3 pypi
