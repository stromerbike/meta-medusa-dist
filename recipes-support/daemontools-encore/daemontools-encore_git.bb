SUMMARY = "daemontools-encore"
HOMEPAGE = "http://untroubled.org/daemontools-encore/"
DESCRIPTION = "daemontools-encore is a collection of tools for managing UNIX services."
SECTION = "System/Servers"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=6bdb502d7342218080b2efcf4b4c4e2a"

PR = "r0"
PV = "1.11+gitr${SRCPV}"
DEPENDS += "daemontools-encore-native"
DEPENDS_class-native = ""

SRC_URI = " \
           git://github.com/bruceg/${BPN}.git;protocol=git;branch=master \
"

SRC_URI_append_class-target = "file://cross-compile.patch \
                               file://0001-daemontools-Fix-QA-Issue.patch"

SRC_URI_append_class-native = "file://host-compile.patch \
                               file://0001-daemontools-native-Fix-a-warning.patch"

SRCREV = "b40600d9ee0aa6025f33f2644207e069315ca64c"

S = "${WORKDIR}/git"

do_configure () {
    ./makemake
}

do_install () {
    install -d ${D}/${bindir}
    for APP in $(cat ${S}/BIN | cut -d: -f6); do
        install -m 755 ${S}/$APP ${D}/${bindir}
    done
}

PACKAGES =+ "multilog"
FILES_multilog = "${bindir}/multilog"

BBCLASSEXTEND = "native"
