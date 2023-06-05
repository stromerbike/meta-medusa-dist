FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://ldattach-adjust-gsm-config.patch \
"

RDEPENDS:${PN} =+ "util-linux-ldattach"
PACKAGES =+ "util-linux-ldattach"
FILES:util-linux-ldattach = "${sbindir}/ldattach"

RDEPENDS:${PN} =+ "util-linux-setterm"
PACKAGES =+ "util-linux-setterm"
FILES:util-linux-setterm = "${bindir}/setterm"
