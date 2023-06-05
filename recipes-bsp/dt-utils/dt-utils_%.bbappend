# https://github.com/phytec/meta-phytec/commit/6daee557d8da028a040c119a1fe72ad205346c9d

inherit update-alternatives

FILES:${PN}-fdtdump += "${bindir}/fdtdump.dt-utils"
RDEPENDS:${PN}-fdtdump += "${PN}"
ALTERNATIVE_PRIORITY = "100"
ALTERNATIVE:${PN}-fdtdump = "fdtdump"
ALTERNATIVE_LINK_NAME[fdtdump] = "${bindir}/fdtdump"
