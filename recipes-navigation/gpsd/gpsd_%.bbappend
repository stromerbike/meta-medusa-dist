SYSTEMD_AUTO_ENABLE_${PN} = "disable"

DEPENDS_append = " python-native"

inherit python-dir

do_install_append() {
    ${STAGING_BINDIR_NATIVE}/python-native/python -m compileall ${D}${PYTHON_SITEPACKAGES_DIR}/gps
}
