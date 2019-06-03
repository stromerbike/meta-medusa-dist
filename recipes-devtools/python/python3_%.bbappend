DEPENDS_remove += "libnsl2"

RRECOMMENDS_${PN}-crypt_remove += "ca-certificates"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://dont-generate-optimized-bytecode.patch \
"
