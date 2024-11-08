DESCRIPTION = "Frame Buffer Viewer"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=130f9d9dddfebd2c6ff59165f066e41c"
DEPENDS = "libpng"
PR = "r0"

SRC_URI = "https://sources.buildroot.net/fbv/fbv-1.0b.tar.gz \
	file://cross_compile.patch \
	file://fbv-1.0b.patch \
	file://png.c.patch \
	"
SRC_URI[md5sum] = "3e466375b930ec22be44f1041e77b55d"
SRC_URI[sha256sum] = "9b55b9dafd5eb01562060d860e267e309a1876e8ba5ce4d3303484b94129ab3c"

do_configure() {
	CC="${CC}" ./configure --without-libungif --without-libjpeg --without-bmp
}

do_compile() {
	oe_runmake CC="${CC}" \
		CFLAGS="-O2 -Wall -D_GNU_SOURCE -D__KERNEL_STRICT_NAMES"		
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 fbv ${D}${bindir}

	install -d ${D}${mandir}/man1/
	install -m 0644 fbv.1 ${D}${mandir}/man1/fbv.1
}
