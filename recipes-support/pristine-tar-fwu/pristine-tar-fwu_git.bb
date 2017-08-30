SUMMARY = "pristine-tar can regenerate a pristine upstream tarball using only a small binary delta file and a revision control checkout of the upstream branch"
HOMEPAGE = "https://github.com/tramseyer/pristine-tar-fwu"
SECTION = "console/utils"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://GPL;md5=751419260aa954499f7abaabaa882bbe"

PR = "r0"
PV = "1.37+gitr${SRCPV}"
DEPENDS = "zlib"

SRC_URI = "git://github.com/tramseyer/${BPN}.git;protocol=git;branch=master"
SRCREV = "1206ba2cc4e9a73c62f26d042284982390a2fca1"

S = "${WORKDIR}/git"

inherit cpan

# https://github.com/kraj/poky/blob/krogoth/meta/recipes-devtools/perl/perl-rdepends_5.22.1.inc
# Depends on cp which is included in coreutils
RDEPENDS_${PN} = " coreutils \
                   tar \
                   xdelta3 \
                   perl \
                   perl-module-digest-sha \
                   perl-module-file-find \
                   perl-module-file-glob \
                   perl-module-file-temp \
                   perl-module-getopt-long \
                   perl-module-ipc-open2 \
                   perl-module-overloading"
