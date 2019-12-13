FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://ldattach-adjust-gsm-config.patch \
"

RDEPENDS_${PN} =+ "util-linux-ldattach"
PACKAGES =+ "util-linux-ldattach"
FILES_util-linux-ldattach = "${sbindir}/ldattach"

RDEPENDS_${PN} =+ "util-linux-setterm"
PACKAGES =+ "util-linux-setterm"
FILES_util-linux-setterm = "${bindir}/setterm"
