PACKAGES =+ "${PN}-mcp"
FILES:${PN}-mcp = "${bindir}/mcp*"

RRECOMMENDS:${PN}:remove = "iproute2"
