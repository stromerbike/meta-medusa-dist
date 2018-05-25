SUMMARY = "pristine-tar can regenerate a pristine upstream tarball using only a small binary delta file and a revision control checkout of the upstream branch"
HOMEPAGE = "https://github.com/tramseyer/pristine-tar-fwu"
SECTION = "console/utils"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://GPL;md5=751419260aa954499f7abaabaa882bbe"

PR = "r0"
PV = "1.42.4+gitr${SRCPV}"
DEPENDS = "zlib"

SRC_URI = "git://github.com/tramseyer/${BPN}.git;protocol=git;branch=master"
SRCREV = "29da46c434358313c303a1f4a037ee874c745ebb"

S = "${WORKDIR}/git"

inherit cpan

# tar 1.30 does not create the same output as tar 1.29 possibly due to changes to --numeric-owner (https://fossies.org/diffs/tar/1.29_vs_1.30/NEWS-diff.html)
# older BSP's and the update server use tar 1.29 and therefore the same version has to be used in the BSP
# https://github.com/kraj/poky/blob/morty/meta/recipes-devtools/perl/perl-rdepends_5.22.1.inc
RDEPENDS_${PN} = " pv \
                   rsync \
                   tar (= 1.29-r0) \
                   xdelta3 \
                   xz \
                   perl \
                   perl-module-digest-sha \
                   perl-module-file-copy \
                   perl-module-file-find \
                   perl-module-file-glob \
                   perl-module-file-temp \
                   perl-module-getopt-long \
                   perl-module-ipc-open2 \
                   perl-module-overloading"
