HOMEPAGE = "https://github.com/aio-libs/aioftp"
SUMMARY = "ftp client/server for asyncio"

SECTION = "devel/python"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://license.txt;md5=86d3f3a95c324c9479bd8986968f4327"

RDEPENDS:${PN} = "python3-asyncio python3-io python3-logging"

SRC_URI[md5sum] = "65cb5b6e6892d123bba63816fd889e69"
SRC_URI[sha256sum] = "baa2b13186aa01622e4b82f27c2f48f4dafb48e457a6b18fcda99a925e0dc270"

SRC_URI += "file://0001-use-hardcoded-version-instead-of-importlib.metadata.patch"

inherit pypi python_setuptools_build_meta
