SUMMARY = "fbtest"
DESCRIPTION = "This program supports you with adjusting display settings."
HOMEPAGE = "https://git.kernel.org/pub/scm/linux/kernel/git/geert/fbtest.git"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=ea5bed2f60d357618ca161ad539f7c0a"

PR = "r1"

# Revert back to kernel.org once ca-certificates has been updated in development environments.
# "git://git.kernel.org/pub/scm/linux/kernel/git/geert/fbtest.git;protocol=https;branch=master"
SRC_URI = "git://kernel.googlesource.com/pub/scm/linux/kernel/git/geert/fbtest;protocol=https;branch=master \
           file://0001-provide-a-pre-generated-penguin.c-to-get-rid-of-this.patch \
           file://add-option-norestore.patch \
           file://repair-make-rules.patch \
"
SRCREV = "dbf4e0bd06410e54617f847f8f33a5280f1b8c93"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}${base_sbindir}
    install -m 755 ${B}/fbtest ${D}${base_sbindir}/fbtest
}
