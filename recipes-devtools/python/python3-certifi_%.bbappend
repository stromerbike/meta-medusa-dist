do_install_append() {
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} -O -m compileall ${D}${PYTHON_SITEPACKAGES_DIR}/certifi
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} -OO -m compileall ${D}${PYTHON_SITEPACKAGES_DIR}/certifi
}
