FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://support-building-with-C++20.patch \
"

# protobuf branch name change
SRC_URI:remove = "git://github.com/protocolbuffers/protobuf.git;destsuffix=git/src/third_party/protobuf/protobuf;name=protobuf;branch=master;protocol=https"
SRC_URI:append = " git://github.com/protocolbuffers/protobuf.git;destsuffix=git/src/third_party/protobuf/protobuf;name=protobuf;branch=main;protocol=https"

RDEPENDS:${PN}-dev += "${PN}-staticdev"

EXTRA_OECONF:append:class-target = " --disable-tools"

do_install:append:class-target() {
    rm ${D}${bindir}/microdump_stackwalk
    rm ${D}${bindir}/minidump_dump
}
