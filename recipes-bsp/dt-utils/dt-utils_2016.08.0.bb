# Copyright (C) 2015 Jan Remmet <j.remmet@phytec.de>
# Released under the MIT license (see COPYING.MIT for the terms)
SUMMARY = "barebox-state tool to interact with 'barebox-state'"
HOMEPAGE = "http://git.pengutronix.de/?p=tools/dt-utils.git"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88"

DEPENDS = "udev"

SRC_URI = "http://www.pengutronix.de/software/dt-utils/download/${BPN}-${PV}.tar.xz"
SRC_URI[sha256sum] = "6fa29f2b38251847376bb78c4a2b6cb126f713a1953c189358e98076cea2dbef"

PR = "r0"

inherit autotools pkgconfig update-alternatives

PACKAGES =+ "${PN}-dtblint ${PN}-barebox-state ${PN}-fdtdump"

FILES_${PN}-dtblint += "${bindir}/dtblint"
RDEPENDS_${PN}-dtblint += "${PN}"

FILES_${PN}-barebox-state += "${bindir}/barebox-state"
RDEPENDS_${PN}-barebox-state += "${PN}"

FILES_${PN}-fdtdump += "${bindir}/fdtdump.dt-utils"
RDEPENDS_${PN}-fdtdump += "${PN}"
ALTERNATIVE_PRIORITY = "100"
ALTERNATIVE_${PN}-fdtdump = "fdtdump"
ALTERNATIVE_LINK_NAME[fdtdump] = "${bindir}/fdtdump"
