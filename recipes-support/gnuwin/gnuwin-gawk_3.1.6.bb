SUMMARY = "Gawk for Windows"
HOMEPAGE = "http://gnuwin32.sourceforge.net/packages/gawk.htm"

LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

SRC_URI = " \ 
            file://awk.exe \
"

FILES:${PN} = "${datadir}/gnuwin/awk.exe"

do_install () {
    install -d ${D}/${datadir}/gnuwin
    install -m 0644 ${WORKDIR}/awk.exe ${D}/${datadir}/gnuwin
}
