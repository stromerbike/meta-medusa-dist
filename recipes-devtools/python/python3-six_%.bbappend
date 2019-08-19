export PYTHONDONTWRITEBYTECODE = "1"

do_install_append_class-target() {
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} -m compileall -b ${D}${PYTHON_SITEPACKAGES_DIR}
    find ${D}${PYTHON_SITEPACKAGES_DIR} -name "*.py" -delete
    rm -r ${D}${PYTHON_SITEPACKAGES_DIR}/six-*.egg-info
}
