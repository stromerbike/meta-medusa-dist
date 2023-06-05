HOMEPAGE = "https://github.com/encode/httpx"
SUMMARY = "A next generation HTTP client for Python."

SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=c624803bdf6fc1c4ce39f5ae11d7bd05"

RDEPENDS:${PN} = "python3-httpcore python3-rfc3986 python3-sniffio python3-certifi python3-codecs python3-netrc python3-netserver"

SRC_URI[md5sum] = "fd9695c3fcef0792f77ec7279ffb6ee5"
SRC_URI[sha256sum] = "507d676fc3e26110d41df7d35ebd8b3b8585052450f4097401c9be59d928c63e"

# The python_hatchling class is only available in Yocto 4.1 and newer.
# To avoid packporting python3-hatchling, add setup.py as it was before removal
# https://github.com/encode/httpx/pull/2334/commits/e1ebecb66d3e83efb0a182a57cc42df29dde2649
# Remark: The dependencies "install_requires" and "extras_require" were not updated
#         as they do not seem to be required for building via Yocto.
SRC_URI += "file://setup.py.patch"

inherit setuptools3 pypi
