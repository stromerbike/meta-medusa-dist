SUMMARY = "fbtest"
DESCRIPTION = "This program supports you with adjusting display settings."
HOMEPAGE = "https://git.kernel.org/pub/scm/linux/kernel/git/geert/fbtest.git"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=ea5bed2f60d357618ca161ad539f7c0a"

PR = "r1"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/geert/fbtest.git \
           file://0001-provide-a-pre-generated-penguin.c-to-get-rid-of-this.patch \
           file://repair-make-rules.patch \
"
SRCREV = "1dda6d8a1ac1ff1c7b93e89f6ee7020f24be8ee8"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}${base_sbindir}
    install -m 755 ${B}/fbtest ${D}${base_sbindir}/fbtest
}
