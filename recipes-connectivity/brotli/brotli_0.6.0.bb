DESCRIPTION = "Google's Brotli compression format"
HOMEPAGE = "https://github.com/google/brotli"
SECTION = "libs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=941ee9cd1609382f946352712a319b4b"

SRC_URI = "\
    https://github.com/google/brotli/archive/v${PV}.tar.gz \
"

SRC_URI[md5sum] = "1dcdcda924ab0c232ce54fa9f2b02624"
SRC_URI[sha256sum] = "69cdbdf5709051dd086a2f020f5abf9e32519eafe0ad6be820c667c3a9c9ee0f"

S = "${WORKDIR}/brotli-${PV}"

inherit cmake

BBCLASSEXTEND = "native nativesdk"
