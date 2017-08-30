SUMMARY = "pristine-tar can regenerate a pristine upstream tarball using only a small binary delta file and a revision control checkout of the upstream branch"
HOMEPAGE = "https://github.com/tramseyer/pristine-tar-fwu"
SECTION = "console/utils"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://GPL;md5=751419260aa954499f7abaabaa882bbe"

PR = "r0"
DEPENDS = "zlib"

SRC_URI = "https://github.com/tramseyer/pristine-tar-fwu/archive/1.37-rc4.tar.gz;downloadfilename=pristine-tar-fwu_1.37-rc4.tar.gz"

SRC_URI[md5sum] = "52014e909ba2ff732b91598bdd0cef63"
SRC_URI[sha256sum] = "195743e5286d7d0e9bbbdf4b4b426d9930416f74e0961bb88371239bae74861c"

inherit cpan

# https://github.com/kraj/poky/blob/krogoth/meta/recipes-devtools/perl/perl-rdepends_5.22.1.inc
# Depends on tar which is included in busybox
RDEPENDS_${PN} = " tar \
                   xdelta3 \
                   perl \
                   perl-module-digest-sha \
                   perl-module-file-find \
                   perl-module-file-glob \
                   perl-module-file-temp \
                   perl-module-getopt-long \
                   perl-module-ipc-open2 \
                   perl-module-overloading"
