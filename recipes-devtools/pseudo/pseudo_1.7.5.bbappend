FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://obey-ldflags.patch \
            file://pseudo-glibc-rtld-next-workaround.patch \
"
