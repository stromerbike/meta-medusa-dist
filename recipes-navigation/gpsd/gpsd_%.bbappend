SYSTEMD_AUTO_ENABLE_${PN} = "disable"

DEPENDS_append = " python-native"

SRC_URI = "http://savannah.spinellicreations.com/${BPN}/${BP}.tar.gz \
    file://0001-SConstruct-prefix-includepy-with-sysroot-and-drop-sy.patch \
    file://0004-SConstruct-disable-html-and-man-docs-building-becaus.patch \
    file://0001-include-sys-ttydefaults.h.patch \
"

inherit python-dir

do_install_append() {
    ${STAGING_BINDIR_NATIVE}/python-native/python -m compileall ${D}${PYTHON_SITEPACKAGES_DIR}/gps
}
