SUMMARY = "Protocol Buffers - structured data serialisation mechanism"
DESCRIPTION = "Protocol Buffers are a way of encoding structured data in an \
efficient yet extensible format. Google uses Protocol Buffers for almost \
all of its internal RPC protocols and file formats."
HOMEPAGE = "https://github.com/google/protobuf"
SECTION = "console/tools"
LICENSE = "BSD-3-Clause"

DEPENDS = "zlib"

LIC_FILES_CHKSUM = "file://LICENSE;md5=af6809583bfde9a31595a58bb4a24514"

SRCREV = "bba83652e1be610bdb7ee1566ad18346d98b843c"

PV = "2.6.1+git${SRCPV}"

SRC_URI = "git://github.com/google/protobuf.git"

EXTRA_OECONF += " --with-protoc=echo"

inherit autotools

S = "${WORKDIR}/git"

BBCLASSEXTEND = "native nativesdk"

# add libprotobuf-lite to main packages
# see https://lists.yoctoproject.org/pipermail/yocto/2013-December/017509.html
FILES_${PN} = "${libdir}/libprotobuf-lite.so*"
FILES_${PN}-dev += " \
    ${libdir}/libprotobuf.so* \
    ${libdir}/libprotoc.so* \
    ${bindir}/protoc \
"
FILES_SOLIBSDEV = ""

INSANE_SKIP_${PN} += "dev-so"
