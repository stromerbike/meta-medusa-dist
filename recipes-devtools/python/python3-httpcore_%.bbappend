do_install:append:class-target() {
    find ${D}${PYTHON_SITEPACKAGES_DIR} -type d -name "__pycache__" -exec rm -r {} +
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} -m compileall -b -s ${D} ${D}${PYTHON_SITEPACKAGES_DIR}
    find ${D}${PYTHON_SITEPACKAGES_DIR} -name "*.py" -delete
    rm -r ${D}${PYTHON_SITEPACKAGES_DIR}/httpcore-*.dist-info
}
