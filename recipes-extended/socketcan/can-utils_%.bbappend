FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
             file://0001-timestamp-formatting-always-use-64-bit-for-timesstam.patch \
"

PACKAGES =+ "${PN}-mcp"
FILES:${PN}-mcp = "${bindir}/mcp*"

RRECOMMENDS:${PN}:remove = "iproute2"
