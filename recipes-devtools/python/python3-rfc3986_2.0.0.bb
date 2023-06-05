HOMEPAGE = "https://github.com/python-hyper/rfc3986"
SUMMARY = "A Python Implementation of RFC3986 including validations"

SECTION = "devel/python"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=03731a0e7dbcb30cecdcec77cc93ec29"

RDEPENDS:${PN} = "python3-idna"

SRC_URI[md5sum] = "bbf20302bf26bc771e88cc775fbde3bc"
SRC_URI[sha256sum] = "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"

inherit setuptools3 pypi
