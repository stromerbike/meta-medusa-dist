SYSTEMD_AUTO_ENABLE_${PN} = "disable"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI = "git://git.savannah.gnu.org/gpsd.git \
    file://0001-SConstruct-prefix-includepy-with-sysroot-and-drop-sy.patch \
    file://0004-SConstruct-disable-html-and-man-docs-building-becaus.patch \
    file://0001-include-sys-ttydefaults.h.patch \
    file://gpsd.service.patch \
"

SRCREV = "18bc54e3ef722495a7ff84db7321c1a399806149"

S = "${WORKDIR}/git"

# As of version 3.17, gpsd cannot be built using python3 (should be possible in future with 3.18).
# In order to still install -pygps for python3, the installation has to be done in a special way.
DEPENDS_append = " python3-native (= 3.5.*)"
FILES_python-pygps  = "${libdir}/python3.5/site-packages/*"
RDEPENDS_python-pygps = " \
    python3-core \
    python3-io \
    python3-threading \
    python3-terminal \
    python3-curses \
    gpsd \
    python3-json \
"
do_install_append() {
    mkdir -p ${D}${libdir}/python3.5/site-packages
    mv ${D}${libdir}/python2.7/site-packages/* ${D}${libdir}/python3.5/site-packages/
    rm -r ${D}${libdir}/python2.7/
    ${STAGING_BINDIR_NATIVE}/python3-native/python3 -m compileall ${D}${libdir}/python3.5/site-packages/gps
}
