DEPENDS_remove += "libnsl2"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://dont-generate-optimized-bytecode.patch \
"
