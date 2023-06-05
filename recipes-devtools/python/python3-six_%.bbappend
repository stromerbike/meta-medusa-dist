export PYTHONDONTWRITEBYTECODE = "1"

do_install:append:class-target() {
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} -m compileall -b ${D}${PYTHON_SITEPACKAGES_DIR}
    find ${D}${PYTHON_SITEPACKAGES_DIR} -name "*.py" -delete
    rm -r ${D}${PYTHON_SITEPACKAGES_DIR}/six-*.dist-info
    # PYTHONDONTWRITEBYTECODE=1 does not disable the creation of .pyc files in their default location
    # possibly because this package is not located in a subfolder within PYTHON_SITEPACKAGES_DIR
    rm -r ${D}${PYTHON_SITEPACKAGES_DIR}/__pycache__/
}
